import 'package:dart_wordlists/dart_wordlists.dart';

main(List<String> arguments) async {
  PgpMnemonic pgpWords = new PgpMnemonic();
  await pgpWords.init();

  if (arguments.length == 0) {
    print("You must supply some words");
  } else {
    print(pgpWords.fromPhraseToHex(arguments));
  }
}
