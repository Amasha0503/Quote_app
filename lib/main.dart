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
      title: "Quote App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const QuotePage(),
    );
  }
}

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  String quote = "Welcome! Tap the button to get a quote.";
  String author = "";
  bool isLoading = false;

  Future<void> fetchQuote() async {
    setState(() {
      isLoading = true;
    });

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
        quote = "Error loading quote";
        author = "";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quote App"),
        centerTitle:false,
        elevation: 4,                    
        backgroundColor: Colors.blueAccent, 
        foregroundColor: Colors.white, 
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
        
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Hey! Did you know that...",
                        style: TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.italic, 
                          color: Colors.grey,           
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12), 
                    
                    isLoading
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                            onHorizontalDragEnd: (_) => fetchQuote(),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue.shade100, Colors.blue.shade50],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '"$quote"',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "- $author",
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  ElevatedButton.icon(
                                    onPressed: fetchQuote,
                                    icon: const Icon(Icons.autorenew),
                                    label: const Text("New Quote"),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}