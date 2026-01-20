import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/question_model.dart';
import '../models/result_model.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  final String variantName;
  final int startIndex;
  final int endIndex;

  const QuizPage({
    super.key,
    required this.variantName,
    required this.startIndex,
    required this.endIndex,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> _quizQuestions = [];
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _isAnswered = false;
  bool _isLoading = true;
  List<WrongQuestion> _wrongQuestionsList = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final String response = await rootBundle.loadString('lib/data/UZTarixTests.json');
      final List<dynamic> data = json.decode(response);

      List<Question> allQuestions = [];
      // JSON ro'yxat ko'rinishida bo'lgani uchun to'g'ridan-to'g'ri o'qiymiz
      for (var item in data) {
        allQuestions.add(Question.fromJson(item));
      }

      setState(() {
        // Savollar sonini tekshiramiz va sublist qilamiz
        int end = widget.endIndex > allQuestions.length ? allQuestions.length : widget.endIndex;
        _quizQuestions = allQuestions.sublist(widget.startIndex, end);
        _isLoading = false;
      });
    } catch (e) {
      print("Yuklashda xatolik: $e");
      setState(() => _isLoading = false);
    }
  }

  void _handleAnswer(String option) {
    if (_isAnswered) return;

    final currentQuestion = _quizQuestions[_currentIndex];
    bool isCorrect = option == currentQuestion.correctOption;

    setState(() {
      _isAnswered = true;
      _selectedOption = option;
      if (isCorrect) {
        _score++;
      } else {
        _wrongQuestionsList.add(WrongQuestion(
          question: currentQuestion.question,
          correctOption: currentQuestion.correctOption,
          correctText: currentQuestion.options[currentQuestion.correctOption] ?? "Noma'lum",
          userOption: option,
          userText: currentQuestion.options[option] ?? "Noma'lum",
        ));
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (_currentIndex < _quizQuestions.length - 1) {
        setState(() {
          _currentIndex++;
          _isAnswered = false;
          _selectedOption = null;
        });
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultPage(
              score: _score,
              total: _quizQuestions.length,
              variantName: widget.variantName,
              wrongQuestions: _wrongQuestionsList,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_quizQuestions.isEmpty) return const Scaffold(body: Center(child: Text("Savollar topilmadi")));

    final currentQuestion = _quizQuestions[_currentIndex];
    final progress = (_currentIndex + 1) / _quizQuestions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: Text(widget.variantName), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(color: Colors.blue.shade700, shape: BoxShape.circle),
                  child: Center(child: Text("${_currentIndex + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))),
                ),
                const SizedBox(width: 10),
                Text("/ ${_quizQuestions.length}", style: const TextStyle(color: Colors.grey, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.blue.shade50)),
              child: Text(currentQuestion.question, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),
            ...currentQuestion.options.entries.map((entry) {
              final isSelected = _selectedOption == entry.key;
              final isCorrect = entry.key == currentQuestion.correctOption;
              Color bgColor = Colors.white;
              Color borderColor = Colors.grey.shade200;
              if (_isAnswered) {
                if (isCorrect) { bgColor = Colors.green.shade50; borderColor = Colors.green; }
                else if (isSelected) { bgColor = Colors.red.shade50; borderColor = Colors.red; }
              } else if (isSelected) { borderColor = Colors.blue; }
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _handleAnswer(entry.key),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15), border: Border.all(color: borderColor, width: 2)),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 15, backgroundColor: isSelected ? Colors.blue : Colors.grey.shade100, child: Text(entry.key, style: TextStyle(color: isSelected ? Colors.white : Colors.black))),
                        const SizedBox(width: 15),
                        Expanded(child: Text(entry.value)),
                        if (_isAnswered && isCorrect) const Icon(Icons.check_circle, color: Colors.green),
                        if (_isAnswered && isSelected && !isCorrect) const Icon(Icons.cancel, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
