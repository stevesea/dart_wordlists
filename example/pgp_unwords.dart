import 'package:dart_wordlists/dart_wordlists.dart';

void main(List<String> arguments) async {
  var pgpWords = PgpMnemonic();
  await pgpWords.init();

  if (arguments.length == 0) {
    print("You must supply some words");
  } else {
    print(pgpWords.fromPhraseToHex(arguments));
  }
}
