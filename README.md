# Piper Phonemizer

**Piper Phonemizer** is a lightweight and efficient text-to-phoneme converter powered by the open-source [Piper TTS engine](https://github.com/rhasspy/piper). This package allows you to convert raw text into phoneme sequences—ideal for speech synthesis, linguistic analysis, pronunciation training, and more.

---

## ✨ Features

- ⚡ **Fast and Lightweight**: Designed for performance and minimal resource usage.
- 🔤 **Text to Phoneme Conversion**: Converts plain text into language-specific phonemes.
- 📦 **FFI-based**: Built in C for speed but easily usable from Dart (Flutter), Python, and more.
- 🌍 **Multi-language Support**: Works with different voices and phoneme schemes.
- 📱 **Mobile Ready**: Optimized for embedded and mobile use cases (like Flutter apps).

---

## 💡 Inspiration

While Piper is a fantastic lightweight TTS engine, there was no simple and reliable way to convert raw text into phonemes that could be directly consumed by Piper for tasks like voice cloning, custom TTS, or linguistic analysis—especially in mobile or embedded environments.

Existing solutions were often:
- Tightly coupled to heavyweight systems,
- Buried inside larger TTS pipelines, or
- Not cross-platform or easy to use with Dart, Flutter, or FFI-based setups.

To bridge this gap, **Piper Phonemizer** was created — a clean, minimal, and efficient way to:
- Generate phonemes with Piper’s models,
- Enable phoneme-level analysis,
- And unlock lower-level control in your TTS workflows.

If you’ve ever wished for a drop-in phonemizer that just works with Piper, especially in a Flutter app or lightweight deployment, this package is for you.


## 🧪 Minimal Reproducible Example

Here’s how to get started in Dart:

```dart
import 'package:piper_phonemizer/piper_phonemizer.dart';

void main() async {
  final phonemizer = PiperPhonemizer();

  await phonemizer.initialize();

  // Optional: Set a voice according to your requirement.
  // For more voice options, check: https://github.com/OHF-Voice/piper1-gpl/blob/main/docs/VOICES.md
  phonemizer.setVoice("en"); // Default English voice

  final phonemes = phonemizer.getPhonemesString('Hello world');
  print('Phonemes: $phonemes');
}
