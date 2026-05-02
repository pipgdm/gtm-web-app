import 'package:flutter/material.dart';
import 'signal_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const Center(child: Text('Scrape page coming soon')),
      const SignalPageContent(),
    ];

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 220,
            color: Colors.black87,
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Finmile',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 32),
                _navItem('Scrape', 0),
                _navItem('Signal', 1),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: pages[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(String title, int index) {
    final isSelected = selectedIndex == index;

    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}