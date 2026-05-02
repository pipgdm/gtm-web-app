import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignalPageContent extends StatefulWidget {
  const SignalPageContent({super.key});

  @override
  State<SignalPageContent> createState() => _SignalPageContentState();
}

class _SignalPageContentState extends State<SignalPageContent> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _result;
  String? _error;

  Future<void> fetchSignal() async {
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://scrape-api-jsml.onrender.com/api/signals'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': _controller.text.trim()}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(data['error'] ?? 'Error');
      }

      setState(() {
        _result = data['result'];
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Signal Finder",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "https://www.gap.com",
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 12),

        ElevatedButton(
          onPressed: _loading ? null : fetchSignal,
          child: Text(_loading ? "Loading..." : "Find Signal"),
        ),

        const SizedBox(height: 20),

        if (_error != null)
          Text(_error!, style: const TextStyle(color: Colors.red)),

        if (_result != null)
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Text(
                      _result!['company'] ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Signal: ${_result!['signal']}"),
                    const SizedBox(height: 10),
                    Text("Why: ${_result!['why_it_matters']}"),
                    const SizedBox(height: 10),
                    Text("Angle: ${_result!['outbound_angle']}"),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}