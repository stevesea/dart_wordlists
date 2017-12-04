import 'dart:async';

import 'dart:convert';
import 'package:dart_wordlists/dart_wordlists.dart';


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
  eff_short_v1_en,
  eff_short_v2_en
}

class WordlistLoader {
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
    return lookup(wordlist).load();
  }

  AbstractWordlistLoader lookup(Wordlist wordlist) {
    if (!wordlistToLoader.containsKey(wordlist))
      throw new ArgumentError("Invalid wordlist enum: $wordlist");
    return wordlistToLoader[wordlist];
  }

}


/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}
