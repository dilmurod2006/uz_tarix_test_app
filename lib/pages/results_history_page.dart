import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/result_model.dart';

class ResultsHistoryPage extends StatefulWidget {
  const ResultsHistoryPage({super.key});

  @override
  State<ResultsHistoryPage> createState() => _ResultsHistoryPageState();
}

class _ResultsHistoryPageState extends State<ResultsHistoryPage> {
  List<QuizResult> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    final String? resultsString = prefs.getString('quiz_results');
    if (resultsString != null) {
      setState(() {
        _results = QuizResult.decode(resultsString);
        _results.sort((a, b) => b.date.compareTo(a.date));
      });
    }
    setState(() => _isLoading = false);
  }

  void _showResultDetails(QuizResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 20),
              Text(
                "${result.variantName} Tahlili",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildMiniStat("To'g'ri", "${result.score}", Colors.green),
                  const SizedBox(width: 10),
                  _buildMiniStat("Xato", "${result.total - result.score}", Colors.red),
                  const SizedBox(width: 10),
                  _buildMiniStat("Foiz", "${(result.score / result.total * 100).toStringAsFixed(0)}%", Colors.blue),
                ],
              ),
              const Divider(height: 30),
              const Text("Xato qilingan savollar:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 10),
              Expanded(
                child: result.wrongQuestions.isEmpty
                    ? const Center(child: Text("Tabriklaymiz! Hamma savolga to'g'ri javob bergansiz."))
                    : ListView.builder(
                        itemCount: result.wrongQuestions.length,
                        itemBuilder: (context, index) {
                          final wrong = result.wrongQuestions[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.red.shade100),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${index + 1}. ${wrong.question}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 10),
                                Text("Sizning javobingiz: ${wrong.userOption}) ${wrong.userText}", style: const TextStyle(color: Colors.red)),
                                const SizedBox(height: 5),
                                Text("To'g'ri javob: ${wrong.correctOption}) ${wrong.correctText}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text("$label: $value", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Natijalar Tarixi")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text("Hali natijalar yo'q"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    final percentage = (result.score / result.total * 100).toStringAsFixed(0);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        onTap: () => _showResultDetails(result),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: Text("$percentage%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(result.variantName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(DateFormat('dd.MM.yyyy HH:mm').format(result.date)),
                        trailing: const Icon(Icons.analytics_outlined, color: Colors.blue),
                      ),
                    );
                  },
                ),
    );
  }
}
