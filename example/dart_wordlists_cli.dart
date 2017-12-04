import 'package:dart_wordlists/dart_wordlists.dart';

import 'dart:convert' show UTF8;

main() async {

  print(await new WordlistLoader().load(Wordlist.bip39_en));
  print(await new WordlistLoader().load(Wordlist.bip39_zh_CW));
  print(await new WordlistLoader().load(Wordlist.diceware_en));
  print(await new WordlistLoader().load(Wordlist.eff_large_en));
}

