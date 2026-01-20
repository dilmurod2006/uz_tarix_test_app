import 'package:flutter/material.dart';
import 'quiz_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> variants = [
      {"name": "1-Variant", "range": "1 - 25", "start": 0, "end": 25},
      {"name": "2-Variant", "range": "26 - 50", "start": 25, "end": 50},
      {"name": "3-Variant", "range": "51 - 75", "start": 50, "end": 75},
      {"name": "4-Variant", "range": "76 - 100", "start": 75, "end": 100},
      {"name": "5-Variant", "range": "101 - 117", "start": 100, "end": 117},
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.blue.shade700],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset('lib/assets/Uzbekistan Flag.png', width: 100),
              const SizedBox(height: 15),
              const Text(
                "Testlar Bo'limi",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Text(
                "Variantlardan birini tanlang",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: variants.length,
                    itemBuilder: (context, index) {
                      final variant = variants[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text("${index + 1}", style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(variant['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          subtitle: Text("Savollar: ${variant['range']}"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizPage(
                                  variantName: variant['name'],
                                  startIndex: variant['start'],
                                  endIndex: variant['end'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
