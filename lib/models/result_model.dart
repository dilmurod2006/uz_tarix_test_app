import 'dart:convert';

class QuizResult {
  final String variantName;
  final int score;
  final int total;
  final DateTime date;
  final List<WrongQuestion> wrongQuestions;

  QuizResult({
    required this.variantName,
    required this.score,
    required this.total,
    required this.date,
    required this.wrongQuestions,
  });

  Map<String, dynamic> toMap() {
    return {
      'variantName': variantName,
      'score': score,
      'total': total,
      'date': date.toIso8601String(),
      'wrongQuestions': wrongQuestions.map((x) => x.toMap()).toList(),
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      variantName: map['variantName'] ?? "Variant",
      score: map['score'],
      total: map['total'],
      date: DateTime.parse(map['date']),
      wrongQuestions: List<WrongQuestion>.from(
        (map['wrongQuestions'] ?? []).map((x) => WrongQuestion.fromMap(x)),
      ),
    );
  }

  static String encode(List<QuizResult> results) => json.encode(
        results.map<Map<String, dynamic>>((r) => r.toMap()).toList(),
      );

  static List<QuizResult> decode(String results) =>
      (json.decode(results) as List<dynamic>)
          .map<QuizResult>((item) => QuizResult.fromMap(item))
          .toList();
}

class WrongQuestion {
  final String question;
  final String correctOption;
  final String correctText;
  final String userOption;
  final String userText;

  WrongQuestion({
    required this.question,
    required this.correctOption,
    required this.correctText,
    required this.userOption,
    required this.userText,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'correctOption': correctOption,
      'correctText': correctText,
      'userOption': userOption,
      'userText': userText,
    };
  }

  factory WrongQuestion.fromMap(Map<String, dynamic> map) {
    return WrongQuestion(
      question: map['question'],
      correctOption: map['correctOption'],
      correctText: map['correctText'],
      userOption: map['userOption'],
      userText: map['userText'],
    );
  }
}
