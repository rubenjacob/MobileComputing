
import 'package:esense_flutter/model/answer.dart';
import 'package:flutter/foundation.dart';

class Question with ChangeNotifier {
  Question();

  String _question;
  List<Answer> _answers = [];

  String get question => _question;
  set question(String value) {
    _question = value;
    notifyListeners();
  }

  List<Answer> get answers => _answers;
  addAnswer(Answer answer) {
    _answers.add(answer);
    notifyListeners();
  }
  removeAnswer(Answer answer) {
    _answers.remove(answer);
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answers': answers.map((answer) => answer.toJson())
    };
  }

  Question.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    for (int i = 0; i < json['answers'].length; i++) {
      addAnswer(Answer.fromJson(json['answers'][i]));
    }
  }

  @override
  String toString() {
    return 'Question{question: $question}';
  }
}