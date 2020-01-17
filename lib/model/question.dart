

import 'package:esense_flutter/model/answer.dart';
import 'package:flutter/foundation.dart';

class Question with ChangeNotifier {
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

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answers': answers.map((answer) => answer.toMap())
    };
  }

  @override
  String toString() {
    return 'Question{question: $question}';
  }
}