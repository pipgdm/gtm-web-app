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
    return const MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  String result = "";
  bool loading = false;

  final String baseUrl = "https://delivery-api-nsmk.onrender.com";

  Future<void> findDelivery() async {
    setState(() {
      loading = true;
      result = "";
    });

    final response = await http.post(
      Uri.parse('$baseUrl/find-delivery-partner'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': controller.text}),
    );

    setState(() {
      result = response.body;
      loading = false;
    });
  }

  Future<void> findSignal() async {
    setState(() {
      loading = true;
      result = "";
    });

    final response = await http.post(
      Uri.parse('$baseUrl/latest-signal'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': controller.text}),
    );

    setState(() {
      result = response.body;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "GTM Signal Tool",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter retailer URL",
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: loading ? null : findDelivery,
                    child: const Text("Find Delivery"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: loading ? null : findSignal,
                    child: const Text("Find Signal"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              if (loading) const CircularProgressIndicator(),

              const SizedBox(height: 20),

              SelectableText(result),
            ],
          ),
        ),
      ),
    );
  }
}