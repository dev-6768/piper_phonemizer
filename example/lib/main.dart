import 'package:flutter/material.dart';
import 'package:piper_phonemizer/piper_phonemizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tester();

  //basic phonemizer app to get phonemes from entered text.
  runApp(const MyApp());
}

void tester() async {
  final phonemizer = PiperPhonemizer();
  await phonemizer.initialize();
  
  //or set a voice according to your convenience, for more voice types look into piper website
  //https://github.com/OHF-Voice/piper1-gpl/blob/main/docs/VOICES.md

  phonemizer.setVoice("en"); 
  
  final phonemes = phonemizer.getPhonemesString('Hello world');
  print('Phonemes: $phonemes');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phonemizer Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: PhonemeWidget(),
    );
  }
}

class PhonemeWidget extends StatefulWidget {
  const PhonemeWidget({super.key});

  @override
  State<PhonemeWidget> createState() => _PhonemeWidgetState();
}

class _PhonemeWidgetState extends State<PhonemeWidget> {
  final TextEditingController _textController = TextEditingController();
  String _phonemeOutput = '';
  bool _loading = false;
  PiperPhonemizer piperPhonemizer = PiperPhonemizer();

  @override
  void initState() {
    super.initState();
    _initializePhonemizer();
  }

  Future<void> _initializePhonemizer() async {
    try {
      await piperPhonemizer.initialize();
    } catch (e) {
      debugPrint("Error initializing Phonemizer: $e");
    }
  }

  Future<void> _convertToPhonemes() async {
    setState(() => _loading = true);
    try {
      final inputText = _textController.text;
      if (inputText.isEmpty) return;

      final phonemes = piperPhonemizer.getPhonemesString(inputText);
      setState(() => _phonemeOutput = phonemes); // join if a list
    } catch (e) {
      setState(() => _phonemeOutput = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Piper compatible phonemizer"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _convertToPhonemes,
              child: _loading ? const CircularProgressIndicator() : const Text('Convert to Phonemes'),
            ),
            const SizedBox(height: 16),
            Text(
              _phonemeOutput.isNotEmpty ? 'Phonemes: $_phonemeOutput' : 'Enter text above to get phonemes.',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
    
    
    
  }
}
