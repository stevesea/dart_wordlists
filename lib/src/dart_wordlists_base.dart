import 'dart:async';
import 'dart:math';

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

  // pgp https://en.wikipedia.org/wiki/PGP_word_list
  pgp_even,
  pgp_odd,
}

/// metadata about the word list
class WordlistMetadata {
  /// human-friendly name for display
  final String uiName;

  /// any tags for the wordlist (for filtering)
  final List<String> tags;

  /// locale for the wordlist
  final String locale;

  /// # of items in the word list
  final int numWords;

  /// more information abbout the wordlist
  final String info;

  /// Construct
  WordlistMetadata(
      {this.uiName, this.tags, this.locale, this.numWords, this.info = ""});

  @override
  String toString() {
    return 'WordlistMetadata{uiName: $uiName, tags: $tags, locale: $locale, numWords: $numWords, info: $info, entropyPerWord: ${entropyPerWord()}}';
  }

  /// the entropy-per-word of the wordlist
  ///
  /// If a passphrase is selected from a universe of N possibilities, where each possibility is equally likely to be chosen, the entropy is log2(N)
  /// If the passphrase is made out of M symbols, each chosen at random from a universe of N possibilities, each equally likely, the entropy is M*log2(N)
  double entropyPerWord() => log(numWords) / log(2);
}

/// Loader for wordlists
class WordlistLoader {
  static Map<Wordlist, WordlistMetadata> wordlistToMetadata = {
    Wordlist.bip39_zh_CW: WordlistMetadata(
        uiName: "BIP39 Chinese Simplified",
        tags: ["BIP39"],
        locale: "zh_CW",
        numWords: 2048),
    Wordlist.bip39_zh_TW: WordlistMetadata(
        uiName: "BIP39 Chinese Traditional",
        tags: ["BIP39"],
        locale: "zh_TW",
        numWords: 2048),
    Wordlist.bip39_en: WordlistMetadata(
        uiName: "BIP39 English", tags: ["BIP39"], locale: "en", numWords: 2048),
    Wordlist.bip39_fr: WordlistMetadata(
        uiName: "BIP39 French", tags: ["BIP39"], locale: "fr", numWords: 2048),
    Wordlist.bip39_it: WordlistMetadata(
        uiName: "BIP39 Italian", tags: ["BIP39"], locale: "it", numWords: 2048),
    Wordlist.bip39_ja: WordlistMetadata(
        uiName: "BIP39 Japanese",
        tags: ["BIP39"],
        locale: "ja",
        numWords: 2048),
    Wordlist.bip39_ko: WordlistMetadata(
        uiName: "BIP39 Korean", tags: ["BIP39"], locale: "ko", numWords: 2048),
    Wordlist.bip39_es: WordlistMetadata(
        uiName: "BIP39 Spanish", tags: ["BIP39"], locale: "es", numWords: 2048),
    Wordlist.diceware_beale_en: WordlistMetadata(
        uiName: "Diceware - Alan Beale variation",
        tags: ["Diceware"],
        locale: "en",
        numWords: 7776,
        info:
            "alternative list that replaces most Americanisms and many obscure words with more recognizable alternatives"),
    Wordlist.diceware_en: WordlistMetadata(
        uiName: "Diceware English (7776 words)",
        tags: ["Diceware"],
        locale: "en",
        numWords: 7776),
    Wordlist.diceware_8k_en: WordlistMetadata(
        uiName: "Diceware English (8k words)",
        tags: ["Diceware"],
        locale: "en",
        numWords: 8192),
    Wordlist.eff_large_en: WordlistMetadata(
        uiName: "EFF Long list (7776 words)",
        tags: ["EFF"],
        locale: "en",
        numWords: 7776,
        info: "improved usability -- easier to spell, less confusing words."),
    Wordlist.eff_short_v1_en: WordlistMetadata(
        uiName: "EFF Short list (v1 - 1296 words)",
        tags: ["EFF"],
        locale: "en",
        numWords: 1296,
        info: "shorter words (max 5 chars), more memorable and distinct."),
    Wordlist.eff_short_v2_en: WordlistMetadata(
        uiName: "EFF Short list (v2 - 1296 words)",
        tags: ["EFF"],
        locale: "en",
        numWords: 1296,
        info:
            "each word has unique 3-char prefix, all words at least edit distance 3 apart"),
    Wordlist.pgp_even: WordlistMetadata(
        uiName: "PGP Word list (even)",
        tags: ["PGP"],
        locale: "en",
        numWords: 256,
        info: "the 'even' pgp wordlist. two syllables."),
    Wordlist.pgp_odd: WordlistMetadata(
        uiName: "PGP Word list (odd)",
        tags: ["PGP"],
        locale: "en",
        numWords: 256,
        info: "the 'odd' pgp wordlist. three syllables."),
  };

  static Map<Wordlist, AbstractWordlistLoader> wordlistToLoader = {
    Wordlist.bip39_zh_CW: SimpleWordlistLoader(
        uri: "package:dart_wordlists/wordlists/bip39/chinese_simplified.txt"),
    Wordlist.bip39_zh_TW: SimpleWordlistLoader(
        uri: "package:dart_wordlists/wordlists/bip39/chinese_traditional.txt"),
    Wordlist.bip39_en: SimpleWordlistLoader(
        uri: "package:dart_wordlists/wordlists/bip39/english.txt"),
    Wordlist.bip39_fr: SimpleWordlistLoader(
        uri: "package:dart_wordlists/wordlists/bip39/french.txt"),
    Wordlist.bip39_it: SimpleWordlistLoader(
        uri: "package:dart_wordlists/wordlists/bip39/italian.txt"),
    Wordlist.bip39_ja: SimpleWordlistLoader(
        uri: "package:dart_wordlists/wordlists/bip39/japanese.txt"),
    Wordlist.bip39_ko: SimpleWordlistLoader(
        uri: "package:dart_wordlists/wordlists/bip39/korean.txt"),
    Wordlist.bip39_es: SimpleWordlistLoader(
        uri: "package:dart_wordlists/wordlists/bip39/spanish.txt"),
    Wordlist.diceware_beale_en: DicewareWordlistLoader(
        uri: "package:dart_wordlists/wordlists/diceware/beale.wordlist.asc"),
    Wordlist.diceware_en: DicewareWordlistLoader(
        uri: "package:dart_wordlists/wordlists/diceware/diceware.wordlist.asc"),
    Wordlist.diceware_8k_en: SimpleWordlistLoader(
        uri: "package:dart_wordlists/wordlists/diceware/diceware8k.txt"),
    Wordlist.eff_large_en: DicewareWordlistLoader(
        uri: "package:dart_wordlists/wordlists/eff/eff_large_wordlist.txt"),
    Wordlist.eff_short_v1_en: DicewareWordlistLoader(
        uri: "package:dart_wordlists/wordlists/eff/eff_short_wordlist_1.txt"),
    Wordlist.eff_short_v2_en: DicewareWordlistLoader(
        uri: "package:dart_wordlists/wordlists/eff/eff_short_wordlist_2_0.txt"),
    Wordlist.pgp_even: SimpleWordlistLoader(
        uri: "package:dart_wordlists/wordlists/pgp/pgp_even.txt"),
    Wordlist.pgp_odd: SimpleWordlistLoader(
        uri: "package:dart_wordlists/wordlists/pgp/pgp_odd.txt"),
  };

  Future<List<String>> load(Wordlist wordlist) async {
    return findLoader(wordlist).load();
  }

  AbstractWordlistLoader findLoader(Wordlist wordlist) {
    if (!wordlistToLoader.containsKey(wordlist)) {
      throw ArgumentError("Invalid wordlist val: $wordlist");
    }
    return wordlistToLoader[wordlist];
  }

  WordlistMetadata findMetadata(Wordlist wordlist) {
    if (!wordlistToMetadata.containsKey(wordlist)) {
      throw ArgumentError("Invalid wordlist val: $wordlist");
    }
    return wordlistToMetadata[wordlist];
  }
}
