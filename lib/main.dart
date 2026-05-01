import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const DeliveryPartnerApp());
}

class DeliveryPartnerApp extends StatelessWidget {
  const DeliveryPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Partner Finder',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController urlController = TextEditingController();
  String result = '';
  bool loading = false;

  Future<void> findDeliveryPartner() async {
    setState(() {
      loading = true;
      result = '';
    });

    try {
      final response = await http.post(
      Uri.parse('https://delivery-api-nsmk.onrender.com/find-delivery-partner'),          headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': urlController.text}),
      );

      setState(() {
        result = response.body;
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Delivery Partner Finder',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter retailer URL',
                  hintText: 'https://www.example.com',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading ? null : findDeliveryPartner,
                child: Text(loading ? 'Checking...' : 'Find delivery partner'),
              ),
              const SizedBox(height: 24),
              SelectableText(result),
            ],
          ),
        ),
      ),
    );
  }
}