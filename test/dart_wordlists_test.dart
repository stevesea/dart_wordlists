import 'package:dart_wordlists/dart_wordlists.dart';
import 'package:dart_wordlists/src/pgp_mnemonic.dart';
import 'package:test/test.dart';

void main() {
  group('test loader', () {
    var wlLoader = WordlistLoader();

    test('First Test', () async {
      var loader = wlLoader.findLoader(Wordlist.bip39_en);
      var words = await loader.load();

      expect(words.length, equals(2048));

      var meta = wlLoader.findMetadata(Wordlist.bip39_en);
      expect(meta.entropyPerWord(), closeTo(11, 0.001));
    });
  });

  group('test pgp', () {
    var pgpWords = PgpMnemonic();

    setUp(() async {
      await pgpWords.init();
    });

    test('verify sizes', () {
      //expect(pgpWords.even.length, 256);
      //expect(pgpWords.odd.length, 256);
    });

    test('spot check', () {
      expect(pgpWords.toEvenWord(0x00), 'aardvark');
      expect(pgpWords.toEvenWord(0x2C), 'Burbank');
      expect(pgpWords.toOddWord(0xEE), 'universe');
      expect(pgpWords.toOddWord(0xF9), 'Waterloo');
    });

    test('trim all', () {
      expect(trimAll('the test works\noh\tboy'), 'thetestworksohboy');
    });

    test('from hex - with lowercase', () {
      expect(pgpWords.toPhraseFromHex('e5'), ['topmost']);
    });

    test('from hex', () {
      expect(pgpWords.toPhraseFromHex('''
        E582 94F2 E9A2 2748 6E8B
        061B 31CC 528F D7FA 3F19
        '''), [
        'topmost',
        'Istanbul',
        'Pluto',
        'vagabond',
        'treadmill',
        'Pacific',
        'brackish',
        'dictator',
        'goldfish',
        'Medusa',
        'afflict',
        'bravado',
        'chatter',
        'revolver',
        'Dupont',
        'midsummer',
        'stopwatch',
        'whimsical',
        'cowbell',
        'bottomless'
      ]);
    });

    test('to hex', () {
      expect(pgpWords.fromPhraseToHex(['Pluto', 'vagabond']), '94f2');
    });
    test('to hex - lowercase', () {
      expect(pgpWords.fromPhraseToHex(['pluto', 'vagabond']), '94f2');
    });

    test('to hex -- bad position', () {
      // NOTE: have to use lambda if using throwsarg
      expect(() => pgpWords.fromPhraseToHex(['Pluto', 'vagabond', 'bottomless']), throwsArgumentError);
    });
  });
}
