import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuotePage(),
    );
  }
}

class QuotePage extends StatefulWidget {
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  String quote = "Click button to load quote";
  String author = "";

  Future<void> fetchQuote() async {
  try {
    final response =
        await http.get(Uri.parse("https://zenquotes.io/api/random"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)[0];

      setState(() {
        quote = data["q"];
        author = data["a"];
      });
    } else {
      setState(() {
        quote = "Failed to load quote";
        author = "";
      });
    }
  } catch (e) {
    setState(() {
      quote = "Error: $e";
      author = "";
    });
  }
}

  @override
  void initState() {
    super.initState();
    fetchQuote(); // load first quote automatically
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quote Generator")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              quote,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "- $author",
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: fetchQuote,
              child: const Text("New Quote"),
            )
          ],
        ),
      ),
    );
  }
}