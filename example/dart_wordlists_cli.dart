import 'package:dart_wordlists/dart_wordlists.dart';

import 'dart:convert' show UTF8;

main() async {

  var words = await new SimpleWordlistLoader(uri: "package:dart_wordlists/wordlists/bip39/english.txt", encoding: UTF8).load();


  print(words);

  var dwWords = await new DicewareWordlistLoader(uri: "package:dart_wordlists/wordlists/diceware/beale.wordlist.asc", encoding: UTF8).load();

  print(dwWords);
}

