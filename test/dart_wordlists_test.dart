import 'package:dart_wordlists/dart_wordlists.dart';
import 'package:test/test.dart';

void main() {
  group('test loader', () {

    var wlLoader = new WordlistLoader();

    setUp(() {
    });

    test('First Test', () async {
      var loader = wlLoader.findLoader(Wordlist.bip39_en);
      var words = await loader.load();

      expect(words.length, equals(2048));
    });
  });
}
