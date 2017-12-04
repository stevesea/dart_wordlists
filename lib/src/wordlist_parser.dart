
import 'dart:async';
import 'package:resource/resource.dart';
import 'dart:convert';

// to load word lists which are have 1 word per line, and all lines belong in the data set
class SimpleWordlistLoader {
  final String uri;
  final Encoding encoding;

  SimpleWordlistLoader({this.uri, this.encoding});

  Future<List<String>> load() async {
    // read from resource as UTF8
    var resource = new Resource(uri);
    var string = await resource.readAsString(encoding: encoding);

    // split string on carriage return
    return string.split("\n").map((s) => s.trim()).where((s) => s.isNotEmpty).toList(growable: false);
  }
}

// diceware-style lists have a integer representing dice rolls & the word on each line
class DicewareWordlistLoader {

  final String uri;
  final Encoding encoding;

  DicewareWordlistLoader({this.uri, this.encoding});

  Future<Map<int, String>> load() async {
    // read from resource as UTF8
    var resource = new Resource(uri);
    var string = await resource.readAsString(encoding: encoding);

    // split string on carriage return, filter empty, then split again on spaces
    var trimmed = string.split("\n").map((s) => s.trim()).where((s) => s.isNotEmpty);
    var trimmedAndSplit = trimmed.map((s) => s.split("\t"));

    return new Map.fromIterable(trimmedAndSplit,
        key: (words) => words[0],
        value: (words) => words[1]);
  }
}