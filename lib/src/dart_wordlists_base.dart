import 'dart:async';

import 'dart:convert';

import 'package:dart_wordlists/src/wordlist_parser.dart';


enum Wordlist {
  // bip39
  bip39_zh_CW, // chinese simplified
  bip39_zh_TW, // chinese traditional
  bip39_en,
  bip39_fr,
  bip39_it,
  bip39_ja,
  bip39_ko,
  bip39_es,

  // diceware
  diceware_beale_en, // Alan Beale, contains fewer Americanisms and obscure words.
  diceware_en, // orig
  diceware_8k_en,

  // eff
  eff_large_en,
  eff_short_v1_en, // 1296 words, memorable & distinct and maxchars 5
  eff_short_v2_en, // 1296 words, 3-letter edit difference, unique 3-char prefix
}

class WordlistMetadata {
  final String uiName;
  final List<String> tags;
  final String locale;
  final int numWords;
  final String info;
  WordlistMetadata({this.uiName, this.tags, this.locale, this.numWords, this.info = ""});

  @override
  String toString() {
    return 'WordlistMetadata{uiName: $uiName, tags: $tags, locale: $locale, numWords: $numWords, info: $info}';
  }
}

class WordlistLoader {
  static Map<Wordlist, WordlistMetadata> wordlistToMetadata = {
    Wordlist.bip39_zh_CW : new WordlistMetadata(uiName: "BIP39 Chinese Simplified", tags: ["BIP39"], locale: "zh_CW", numWords: 2048),
    Wordlist.bip39_zh_TW : new WordlistMetadata(uiName: "BIP39 Chinese Traditional", tags: ["BIP39"], locale: "zh_TW", numWords: 2048),
    Wordlist.bip39_en : new WordlistMetadata(uiName: "BIP39 English", tags: ["BIP39"], locale: "en", numWords: 2048),
    Wordlist.bip39_fr : new WordlistMetadata(uiName: "BIP39 French", tags: ["BIP39"], locale: "fr", numWords: 2048),
    Wordlist.bip39_it : new WordlistMetadata(uiName: "BIP39 Italian", tags: ["BIP39"], locale: "it", numWords: 2048),
    Wordlist.bip39_ja : new WordlistMetadata(uiName: "BIP39 Japanese", tags: ["BIP39"], locale: "ja", numWords: 2048),
    Wordlist.bip39_ko : new WordlistMetadata(uiName: "BIP39 Korean", tags: ["BIP39"], locale: "ko", numWords: 2048),
    Wordlist.bip39_es : new WordlistMetadata(uiName: "BIP39 Spanish", tags: ["BIP39"], locale: "es", numWords: 2048),

    Wordlist.diceware_beale_en : new WordlistMetadata(uiName: "Diceware - Alan Beale variation", tags: ["Diceware"], locale: "en", numWords: 7776, info: "alternative list that replaces most Americanisms and many obscure words with more recognizable alternatives"),
    Wordlist.diceware_en : new WordlistMetadata(uiName: "Diceware English (7776 words)", tags: ["Diceware"], locale: "en", numWords: 7776),
    Wordlist.diceware_8k_en : new WordlistMetadata(uiName: "Diceware English (8k words)", tags: ["Diceware"], locale: "en", numWords: 8192),

    Wordlist.eff_large_en : new WordlistMetadata(uiName: "EFF Long list (7776 words)", tags: ["EFF"], locale: "en", numWords: 7776, info: "improved usability -- easier to spell, less confusing words."),
    Wordlist.eff_short_v1_en : new WordlistMetadata(uiName: "EFF Short list (v1 - 1296 words)", tags: ["EFF"], locale: "en", numWords: 1296, info: "shorter words (max 5 chars), more memorable and distinct."),
    Wordlist.eff_short_v2_en : new WordlistMetadata(uiName: "EFF Short list (v2 - 1296 words)", tags: ["EFF"], locale: "en", numWords: 1296, info: "each word has unique 3-char prefix, all words at least edit distance 3 apart"),
  };

  static Map<Wordlist, AbstractWordlistLoader> wordlistToLoader = {
    Wordlist.bip39_zh_CW : new SimpleWordlistLoader(uri: "package:dart_wordlists/wordlists/bip39/chinese_simplified.txt", encoding: UTF8),
    Wordlist.bip39_zh_TW : new SimpleWordlistLoader(uri: "package:dart_wordlists/wordlists/bip39/chinese_traditional.txt", encoding: UTF8),
    Wordlist.bip39_en : new SimpleWordlistLoader(uri: "package:dart_wordlists/wordlists/bip39/english.txt", encoding: UTF8),
    Wordlist.bip39_fr : new SimpleWordlistLoader(uri: "package:dart_wordlists/wordlists/bip39/french.txt", encoding: UTF8),
    Wordlist.bip39_it : new SimpleWordlistLoader(uri: "package:dart_wordlists/wordlists/bip39/italian.txt", encoding: UTF8),
    Wordlist.bip39_ja : new SimpleWordlistLoader(uri: "package:dart_wordlists/wordlists/bip39/japanese.txt", encoding: UTF8),
    Wordlist.bip39_ko : new SimpleWordlistLoader(uri: "package:dart_wordlists/wordlists/bip39/korean.txt", encoding: UTF8),
    Wordlist.bip39_es : new SimpleWordlistLoader(uri: "package:dart_wordlists/wordlists/bip39/spanish.txt", encoding: UTF8),

    Wordlist.diceware_beale_en : new DicewareWordlistLoader(uri: "package:dart_wordlists/wordlists/diceware/beale.wordlist.asc", encoding: UTF8),
    Wordlist.diceware_en : new DicewareWordlistLoader(uri: "package:dart_wordlists/wordlists/diceware/diceware.wordlist.asc", encoding: UTF8),
    Wordlist.diceware_8k_en : new SimpleWordlistLoader(uri: "package:dart_wordlists/wordlists/diceware/diceware8k.txt", encoding: UTF8),

    Wordlist.eff_large_en : new DicewareWordlistLoader(uri: "package:dart_wordlists/wordlists/eff/eff_large_wordlist.txt", encoding: UTF8),
    Wordlist.eff_short_v1_en : new DicewareWordlistLoader(uri: "package:dart_wordlists/wordlists/eff/eff_short_wordlist_1.txt", encoding: UTF8),
    Wordlist.eff_short_v2_en : new DicewareWordlistLoader(uri: "package:dart_wordlists/wordlists/eff/eff_short_wordlist_2_0.txt", encoding: UTF8),
  };

  Future<List<String>> load(Wordlist wordlist) async {
    return findLoader(wordlist).load();
  }

  AbstractWordlistLoader findLoader(Wordlist wordlist) {
    if (!wordlistToLoader.containsKey(wordlist))
      throw new ArgumentError("Invalid wordlist val: $wordlist");
    return wordlistToLoader[wordlist];
  }

  WordlistMetadata findMetadata(Wordlist wordlist) {
    if (!wordlistToMetadata.containsKey(wordlist))
      throw new ArgumentError("Invalid wordlist val: $wordlist");
    return wordlistToMetadata[wordlist];
  }

}
