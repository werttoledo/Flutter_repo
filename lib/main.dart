import 'package:flutter/material.dart';
import 'dart:collection';

void main() {
  runApp(WordCounterApp());
}

class WordCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WordCounterScreen(),
    );
  }
}

class WordCounterScreen extends StatefulWidget {
  @override
  _WordCounterScreenState createState() => _WordCounterScreenState();
}

class _WordCounterScreenState extends State<WordCounterScreen> {
  final TextEditingController _textController = TextEditingController();
  Map<String, int> _wordCount = HashMap();

  // Función para eliminar tildes
  String removeDiacritics(String text) {
    final diacritics = {
      'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u',
      'Á': 'A', 'É': 'E', 'Í': 'I', 'Ó': 'O', 'Ú': 'U',
      // Añade más caracteres con tilde si es necesario
    };

    return text.splitMapJoin(
      RegExp('[áéíóúÁÉÍÓÚ]'),
      onMatch: (m) => diacritics[m.group(0)]!,
      onNonMatch: (n) => n,
    );
  }

  void _countWords() {
    String text = _textController.text.toLowerCase();
    text = removeDiacritics(text);
    text = text.replaceAll(RegExp(r'[^a-zA-Z\s]'), ''); 
    List<String> words = text.split(RegExp(r'\s+')); 

    Map<String, int> count = HashMap();
    for (String word in words) {
      if (word.isNotEmpty) {
        count[word] = (count[word] ?? 0) + 1;
      }
    }

    setState(() {
      _wordCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Counter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/images.jpeg',
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Ingrese un párrafo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _countWords,
              child: Text('Contar Palabras'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _wordCount.length,
                itemBuilder: (context, index) {
                  String word = _wordCount.keys.elementAt(index);
                  int count = _wordCount[word]!;
                  return ListTile(
                    title: Text('$word: $count'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
