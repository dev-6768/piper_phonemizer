import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:piper_phonemizer/utils/unzip_espeak_data.dart';


final class _PhonemeResult extends Struct {
  external Pointer<Utf8> phonemes;
  external Pointer<Utf8> terminator;
  @Int32()
  external int isSentence;
}


/// Wrapper class for espeakbridge.so
class PiperPhonemizer {
  /// Singleton instance
  static PiperPhonemizer? _instance;

  factory PiperPhonemizer() {
    return _instance ??= PiperPhonemizer._internal();
  }

  late final DynamicLibrary _lib;

  PiperPhonemizer._internal() {
    _lib = _openLibrary();
  }

  /// Opens the correct `.so` file for Android
  DynamicLibrary _openLibrary() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open("espeakbridge.so");
    }
    throw UnsupportedError("ESpeakBridge is only supported on Android.");
  }

  // FFI Struct matching the native PhonemeResult  

  // Native functions
  late final int Function(Pointer<Utf8> dataDir) _initialize = 
      _lib.lookupFunction<Int32 Function(Pointer<Utf8>), int Function(Pointer<Utf8>)>("initialize");

  late final int Function(Pointer<Utf8> voice) _setVoice =
      _lib.lookupFunction<Int32 Function(Pointer<Utf8>), int Function(Pointer<Utf8>)>("set_voice");

  late final Pointer<_PhonemeResult> Function(Pointer<Utf8> text, Pointer<Int32> count) _getPhonemes =
      _lib.lookupFunction<Pointer<_PhonemeResult> Function(Pointer<Utf8>, Pointer<Int32>),
                         Pointer<_PhonemeResult> Function(Pointer<Utf8>, Pointer<Int32>)>("get_phonemes");

  late final void Function(Pointer<_PhonemeResult>, int) _freePhonemes =
      _lib.lookupFunction<Void Function(Pointer<_PhonemeResult>, Int32),
                         void Function(Pointer<_PhonemeResult>, int)>("free_phonemes");

  /// Initialize espeakbridge with optional data directory
  Future<int> initialize() async {
    final dataDir = await unzipEspeakData();
    print(dataDir);
    final dirPtr = dataDir.toNativeUtf8();
    final result = _initialize(dirPtr);
    malloc.free(dirPtr);
    return result;
  }

  /// Set voice by name
  int setVoice(String voice) {
    final ptr = voice.toNativeUtf8();
    final result = _setVoice(ptr);
    malloc.free(ptr);
    return result;
  }

  /// Get phonemes string from text
  String getPhonemesString(String text) {
    final textPtr = text.toNativeUtf8();
    final countPtr = malloc<Int32>();
    countPtr.value = 0;

    final results = _getPhonemes(textPtr, countPtr);

    final count = countPtr.value;
    malloc.free(countPtr);
    malloc.free(textPtr);

    if (results.address == 0 || count == 0) return "";

    final buffer = StringBuffer();
    for (var i = 0; i < count; i++) {
      final phonemePtr = results[i].phonemes;
      final termPtr = results[i].terminator;

      if (phonemePtr.address != 0) {
        buffer.write(phonemePtr.toDartString());
      }
      if (termPtr.address != 0) {
        buffer.write(termPtr.toDartString());
      }
    }

    _freePhonemes(results, count);

    return buffer.toString();
  }
}
