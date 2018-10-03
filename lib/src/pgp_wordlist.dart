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

  int fromEvenWord(String s) {
    assert(evenMap != null);
    if (!evenMap.inverse.containsKey(s)) {
      throw new ArgumentError.value(s);
    }
    return evenMap.inverse[s];
  }

  int fromOddWord(String s) {
    assert(oddMap != null);
    if (!oddMap.inverse.containsKey(s)) {
      throw new ArgumentError.value(s);
    }
    return oddMap.inverse[s];
  }

  /// given a pgp-wordlist phrase, output the byte equivalent
  Uint8List fromPhrase(List<String> phrase) {
    return List.of([0]);
  }

  String fromPhraseToHex(List<String> phrase) {
    return "0xdeadbeef";
  }

  /// given a byte array, return the pgp-wordlist phrase
  List<String> toPhrase(Uint8List bytes) {
    List<String> ret = [];
    for (var i = 0; i < bytes.length; i++) {
      if (i.isEven) {
        ret.add(toEvenWord(bytes[i]));
      } else {
        ret.add(toOddWord(bytes[i]));
      }
    }
    return ret;
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
