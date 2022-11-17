import 'package:hbot/core/phrase_generator.dart';
import 'package:test/test.dart';

void main() {
  group('phrase generator', () {
    test('simple phrase w/ <start>', () {
      final phraseGenerator = PhraseGenerator.fromString('''{
<start>
test
}''');
      expect(phraseGenerator.generatePhrase(), equals('test'));
    });

    test('simple phrase w/o <start>', () {
      final phraseGenerator = PhraseGenerator.fromString('''{
<begin>
test
}''');
      expect(phraseGenerator.generatePhrase(), equals('test'));
    });

    test('empty phrase', () {
      final phraseGenerator = PhraseGenerator.fromString('''''');
      expect(phraseGenerator.generatePhrase(), equals(''));
    });

    test('start preferred even if not first', () {
      final phraseGenerator = PhraseGenerator.fromString('''{
<begin>
bad
}
{
<start>
good
}''');
      expect(phraseGenerator.generatePhrase(), equals('good'));
    });

    test('first preferred w/o start', () {
      final phraseGenerator = PhraseGenerator.fromString('''{
<first>
good
}
{
<second>
bad
}''');
      expect(phraseGenerator.generatePhrase(), equals('good'));
    });
  });
}
