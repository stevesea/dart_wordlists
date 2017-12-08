import 'package:dart_wordlists/dart_wordlists.dart';
import 'package:dart_collection_sampler/dart_collection_sampler.dart';

import 'package:args/args.dart';


main(List<String> arguments) async {
  var argParser = new ArgParser()
    ..addOption("num", abbr: "n",
        help: "words to pick from wordlist",
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
  for (var wl in wordlists) {
    var meta = loader.findMetadata(wl);
    print(loader.findMetadata(wl));

    var words = await loader.findLoader(wl).load();
    print(words);

    print ("sample: ${sampler.pickN(words, sampleSize, unique: false)}");
    print ("\n");
  }
}

