import 'package:args/args.dart';
import 'package:dart_collection_sampler/dart_collection_sampler.dart';
import 'package:dart_wordlists/dart_wordlists.dart';

void main(List<String> arguments) async {
  var argParser = ArgParser()
    ..addOption("num",
        abbr: "n", help: "words to pick from wordlist", defaultsTo: "6");

  var results = argParser.parse(arguments);

  sample(int.parse(results["num"]));
}

void sample(int sampleSize) async {
  var loader = WordlistLoader();

  var sampler = CollectionSampler();

  var wordlists = [
    Wordlist.bip39_zh_CW,
    Wordlist.diceware_beale_en,
    Wordlist.eff_large_en,
    Wordlist.eff_short_v1_en,
  ];
  for (final wl in wordlists) {
    var meta = loader.findMetadata(wl);
    print(loader.findMetadata(wl));

    var words = await loader.findLoader(wl).load();
    print(words);

    print("sample: ${sampler.pickN(words, sampleSize, unique: false)}");
    print("\n");
  }
}
