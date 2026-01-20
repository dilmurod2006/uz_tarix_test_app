class Question {
  final int id;
  final String topicName;
  final String note;
  final String question;
  final Map<String, String> options;
  final String correctOption;
  final String explanation;

  Question({
    required this.id,
    required this.topicName,
    required this.note,
    required this.question,
    required this.options,
    required this.correctOption,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      topicName: json['topic_name'] ?? "Tarix",
      note: json['note'] ?? "",
      question: json['question'] ?? "",
      options: Map<String, String>.from(json['options'] ?? {}),
      correctOption: json['correct_option'] ?? json['answer'] ?? "A",
      explanation: json['explanation'] ?? "",
    );
  }
}
