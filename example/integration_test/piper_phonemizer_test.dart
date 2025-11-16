
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:piper_phonemizer/piper_phonemizer.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('FFI phoneme conversion test', (WidgetTester tester) async {
    final phonemizer = PiperPhonemizer();

    // Step 1: Initialize (unzips assets if needed)
    final dataPath = await phonemizer.initialize();
    expect(dataPath, isNotNull);

    // Step 2: Convert text to phonemes
    final result = phonemizer.getPhonemesString("Hello world");
    print("Phonemes: $result");

    // Assert that the result is not empty
    expect(result, isNotEmpty);
  });
}