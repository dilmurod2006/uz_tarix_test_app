import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/result_model.dart';
import '../main.dart';

class ResultPage extends StatefulWidget {
  final int score;
  final int total;
  final String variantName;
  final List<WrongQuestion> wrongQuestions;

  const ResultPage({
    super.key,
    required this.score,
    required this.total,
    required this.variantName,
    required this.wrongQuestions,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  Future<void> _saveResult() async {
    final prefs = await SharedPreferences.getInstance();
    final String? resultsString = prefs.getString('quiz_results');
    List<QuizResult> results = resultsString != null ? QuizResult.decode(resultsString) : [];
    
    results.add(QuizResult(
      variantName: widget.variantName,
      score: widget.score,
      total: widget.total,
      date: DateTime.now(),
      wrongQuestions: widget.wrongQuestions,
    ));
    
    await prefs.setString('quiz_results', QuizResult.encode(results));
  }

  @override
  Widget build(BuildContext context) {
    final double percentage = (widget.score / widget.total) * 100;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Natija"), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(widget.variantName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: widget.score / widget.total,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade200,
                    color: percentage >= 70 ? Colors.green : Colors.orange,
                  ),
                ),
                Text("${percentage.toStringAsFixed(0)}%", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 30),
            _buildStatRow("To'g'ri javoblar:", "${widget.score}", Colors.green),
            _buildStatRow("Xato javoblar:", "${widget.total - widget.score}", Colors.red),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainNavigationPage(initialIndex: 1)),
                (route) => false,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Natijalarni ko'rish", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
