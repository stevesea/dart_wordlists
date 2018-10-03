import 'package:dart_wordlists/dart_wordlists.dart';

main(List<String> arguments) async {
  PgpMnemonic pgpWords = new PgpMnemonic();
  await pgpWords.init();

  if (arguments.length == 0) {
    print("You must supply a hex string (whitespace separation a-ok!)");
  } else {
    print(pgpWords.toPhraseFromHex(arguments.join(' ')).join(' '));
  }
}
