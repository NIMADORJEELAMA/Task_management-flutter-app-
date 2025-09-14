import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DebugKeywordsScreen extends StatefulWidget {
  const DebugKeywordsScreen({super.key});

  @override
  State<DebugKeywordsScreen> createState() => _DebugKeywordsScreenState();
}

class _DebugKeywordsScreenState extends State<DebugKeywordsScreen> {
  List<dynamic> keywords = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchKeywords();
  }

  Future<void> fetchKeywords() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:5000/api/keywords"), // Android Emulator
      );

      if (response.statusCode == 200) {
        setState(() {
          keywords = jsonDecode(response.body);
          loading = false;
        });
      } else {
        setState(() {
          error = "Failed with status ${response.statusCode}";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Debug Keywords")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text("Error: $error"))
              : ListView.builder(
                  itemCount: keywords.length,
                  itemBuilder: (context, index) {
                    final k = keywords[index];
                    return ListTile(
                      title: Text(k['keyword'] ?? "No keyword"),
                      subtitle: Text("ID: ${k['id'] ?? k['_id']}"),
                    );
                  },
                ),
    );
  }
}
