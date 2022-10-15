# dart_wordlists
[![Pub Package](https://img.shields.io/pub/v/dart_wordlists.svg)](https://pub.dartlang.org/packages/dart_wordlists)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)

A library for passphrase word lists. Inspired by Diceware and others

## Usage

### generate pgp mnemonic from byte array

```dart
import 'package:dart_wordlists/dart_wordlists.dart';

main(List<String> arguments) async {
  PgpMnemonic pgpWords = new PgpMnemonic();
  await pgpWords.init();

  if (arguments.isEmpty) {
    print("You must supply a hex string (whitespace separation a-ok!)");
  } else {
    print(pgpWords.toPhraseFromHex(arguments.join(' ')).join(' '));
  }
}
```
running the example:
```console
foo@bar$ pub run example/pgp_words.dart a2b4 ff5a 21a9
rebirth politeness Zulu existence blackjack passenger

foo@bar$ pub run example/pgp_unwords.dart rebirth politeness Zulu existence blackjack passenger
a2b4ff5a21a9
```


### word list selection w/ collection sampler

A simple usage example:

```dart
import 'package:dart_wordlists/dart_wordlists.dart';
import 'package:dart_collection_sampler/dart_collection_sampler.dart';

import 'package:args/args.dart';


main(List<String> arguments) async {
  var argParser = new ArgParser()
    ..addOption("num", abbr: "n",
        help: "items to pick from rest of command line",
        defaultsTo: "6");

  var results = argParser.parse(arguments);

  sample(int.parse(results["num"]));
}

sample(int sampleSize) async {
  var loader = new WordlistLoader();

  var sampler = new CollectionSampler();

  var wordlists = [
    Wordlist.bip39_en,
    Wordlist.bip39_zh_CW,
    Wordlist.diceware_beale_en,
    Wordlist.eff_large_en
  ];
  for (final wl in wordlists) {
    var meta = loader.findMetadata(wl);
    print(loader.findMetadata(wl));

    var words = await loader.findLoader(wl).load();
    print(words);

    print ("sample: ${sampler.pickN(words, sampleSize)}");
    print ("\n");
  }
}
```



## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/stevesea/dart_wordlists/issues

## Similar projects

## Credits


### Diceware

diceware is a concept invented by Arnold G. Reinhold, Cambridge, Massachusetts
USA.

The English Diceware Wordlists used with this programme are licensed
by Arnold G. Reinhold (files ``wordlists/wordlist_en_orig.asc``,
``wordlists/wordlist_en.txt``) under the `Creative Commons CC-BY 3.0`
license (see http://creativecommons.org/licenses/by/3.0/).

"Diceware" is a trademark of A G Reinhold.

### EFF

The EFF wordlist (file ``wordlsts/wordlist_en_eff.txt``) is licensed
by the Electronic Frontier Foundation under the `Creative Commons
CC-BY 3.0 US` license (see
https://creativecommons.org/licenses/by/3.0/us/).

See [EFF's New Wordlists for Random Passphrases](https://www.eff.org/deeplinks/2016/07/new-wordlists-random-passphrases)


### BIP39

See [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
