import 'dart:async';
import 'dart:core';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dart_wordlists/src/dart_wordlists_base.dart';
import 'package:memoize/memoize.dart';
import 'package:quiver/collection.dart';
import 'package:quiver/strings.dart';

var memoizedLoader = imemo2((WordlistLoader loader, Wordlist wl) => loader.findLoader(wl).load());

/// translate from binary data to a human-readable collection of words, and vice versa
///    https://en.wikipedia.org/wiki/PGP_word_list
class PgpWords {
  WordlistLoader loader;
  BiMap<int, String> evenMap;
  BiMap<int, String> oddMap;

  PgpWords({WordlistLoader wlLoader}) : loader = wlLoader != null ? wlLoader : new WordlistLoader();

  Future<void> init() async {
    evenMap = HashBiMap();
    oddMap = HashBiMap();

    List<String> even = await memoizedLoader(loader, Wordlist.pgp_even);
    List<String> odd = await memoizedLoader(loader, Wordlist.pgp_odd);

    evenMap.addAll(even.asMap());
    oddMap.addAll(odd.asMap());
  }

  String toEvenWord(int b) {
    assert(evenMap != null);
    RangeError.checkValueInInterval(b, 0, 256);
    return evenMap[b];
  }

  String toOddWord(int b) {
    assert(oddMap != null);
    RangeError.checkValueInInterval(b, 0, 256);
    return oddMap[b];
  }

  /// returns null if word not in list
  int fromEvenWord(String s) {
    assert(evenMap != null);
    return evenMap.inverse[s];
  }

  /// returns null if word not in list
  int fromOddWord(String s) {
    assert(oddMap != null);
    return oddMap.inverse[s];
  }

  /// given a pgp-wordlist phrase, output the byte equivalent
  Uint8List fromPhrase(List<String> phrase) {
    /*
    List<int> ret = [];
    for (var i = 0; i < phrase.length; i++) {
      int val = i.isEven ? fromEvenWord(phrase[i]) : fromOddWord(phrase[i]);
      if (val == null) {
        throw new ArgumentError.value(phrase[i], 'Invalid word "${phrase[i]}" at position $i');
      }
      ret.add(val);
    }
    return Uint8List.fromList(ret);
    */
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

  static String normalizeHexStr(String weirdHex) {
    return trimAll(weirdHex).toUpperCase();
  }

  /// trim all whitespace from the string -- both inside and outside of words
  static String trimAll(String strWithWhitespace) {
    return strWithWhitespace.runes.where((rune) => !isWhitespace(rune)).map((rune) => String.fromCharCode(rune)).join();
  }
}
