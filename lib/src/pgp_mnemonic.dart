import 'dart:async';
import 'dart:collection';
import 'dart:core';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dart_wordlists/src/dart_wordlists_base.dart';
import 'package:memoize/memoize.dart';
import 'package:quiver/strings.dart';

var memoizedLoader = imemo2((WordlistLoader loader, Wordlist wl) => loader.findLoader(wl).load());

/// trim all whitespace from the string -- both inside and outside of words
String trimAll(String strWithWhitespace) {
  return strWithWhitespace.runes.where((rune) => !isWhitespace(rune)).map((rune) => String.fromCharCode(rune)).join();
}

/// translate from binary data to a human-readable collection of words, and vice versa
///    https://en.wikipedia.org/wiki/PGP_word_list
class PgpMnemonic {
  WordlistLoader loader;
  // quiver's bimap doesn't let us supply our own equals method, so we can't use ignore-case
  Map<int, String> evenIntToWord;
  Map<String, int> evenWordToInt;
  Map<int, String> oddIntToWord;
  Map<String, int> oddWordToInt;

  PgpMnemonic({WordlistLoader wlLoader}) : loader = wlLoader != null ? wlLoader : new WordlistLoader();

  Future<void> init() async {
    evenIntToWord = HashMap();
    evenWordToInt = HashMap(equals: (k1, k2) => equalsIgnoreCase(k1, k2), hashCode: (k) => k.toLowerCase().hashCode);
    oddIntToWord = HashMap();
    oddWordToInt = HashMap(equals: (k1, k2) => equalsIgnoreCase(k1, k2), hashCode: (k) => k.toLowerCase().hashCode);

    List<String> even = await memoizedLoader(loader, Wordlist.pgp_even);
    List<String> odd = await memoizedLoader(loader, Wordlist.pgp_odd);

    if (even.length != 256) throw new ArgumentError("pgp even word list is not 256 words long!");
    if (odd.length != 256) throw new ArgumentError("pgp odd word list is not 256 words long!");

    even.asMap().forEach((i, s) {
      evenIntToWord[i] = s;
      evenWordToInt[s] = i;
    });

    odd.asMap().forEach((i, s) {
      oddIntToWord[i] = s;
      oddWordToInt[s] = i;
    });
  }

  String toEvenWord(int b) {
    assert(evenIntToWord != null);
    RangeError.checkValueInInterval(b, 0, 256);
    return evenIntToWord[b];
  }

  String toOddWord(int b) {
    assert(oddIntToWord != null);
    RangeError.checkValueInInterval(b, 0, 256);
    return oddIntToWord[b];
  }

  /// returns null if word not in list
  int fromEvenWord(String s) {
    assert(evenWordToInt != null);
    assert(s != null);
    return evenWordToInt[s];
  }

  /// returns null if word not in list
  int fromOddWord(String s) {
    assert(oddWordToInt != null);
    assert(s != null);
    return oddWordToInt[s];
  }

  /// given a pgp-wordlist phrase, output the equivalent as a byte array
  Uint8List fromPhrase(List<String> phrase) {
    return Uint8List.fromList(phrase
        .asMap()
        .map((i, word) {
          int val = i.isEven ? fromEvenWord(word) : fromOddWord(word);
          if (val == null) {
            int valOther = !i.isEven ? fromEvenWord(word) : fromOddWord(word);
            if (valOther == null) {
              // word isn't in either of the lists.
              throw ArgumentError('Unknown word "${word}" at position $i');
            } else {
              // word is in other list, which means the user transposed
              throw ArgumentError('Misplaced word "${word}" at position $i');
            }
          }
          return MapEntry(i, val);
        })
        .values
        .toList());
  }

  String fromPhraseToHex(List<String> phrase) {
    return hex.encode(fromPhrase(phrase));
  }

  /// given a byte array, return the pgp-wordlist phrase
  List<String> toPhrase(Uint8List bytes) {
    return bytes
        .asMap()
        .map((i, b) => MapEntry(i, i.isEven ? toEvenWord(bytes[i]) : toOddWord(bytes[i])))
        .values
        .toList();
  }

  /// given a string of hex characters, return the pgp-wordlist phrase
  List<String> toPhraseFromHex(String hexStr) {
    return toPhrase(hex.decode(trimAll(hexStr)));
  }
}
