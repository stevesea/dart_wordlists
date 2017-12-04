import 'package:dart_wordlists/dart_wordlists.dart';

import 'package:resource/resource.dart';
import 'dart:convert' show UTF8;

main() async {
  var resource = new Resource("package:dart_wordlists/wordlists/bip39/english.txt");
  var string = await resource.readAsString(encoding: UTF8);
  print(string);
}

