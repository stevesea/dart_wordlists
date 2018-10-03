import 'package:args/args.dart';
import 'package:dart_wordlists/dart_wordlists.dart';

main(List<String> arguments) async {
  var argParser = new ArgParser()..addOption("num", abbr: "n", help: "words to pick from wordlist", defaultsTo: "6");

  var results = argParser.parse(arguments);

  PgpWords pgpWords = new PgpWords();
  await pgpWords.init();

  var words = results.rest.join(' ');

  var phrase = pgpWords.toPhraseFromHex(words);
  print(phrase.join(' '));
}
