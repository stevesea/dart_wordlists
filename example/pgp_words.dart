import 'package:dart_wordlists/dart_wordlists.dart';

void main(List<String> arguments) async {
  var pgpWords = PgpMnemonic();
  await pgpWords.init();

  if (arguments.isEmpty) {
    print("You must supply a hex string (whitespace separation a-ok!)");
  } else {
    print(pgpWords.toPhraseFromHex(arguments.join(' ')).join(' '));
  }
}
