

import 'package:flutter/foundation.dart';

class Answer with ChangeNotifier {
  String _answer;
  bool _correct = false;

  String get answer => _answer;
  set answer(String value) {
    _answer = value;
    notifyListeners();
  }
  toggleCorrect() {
    _correct = !_correct;
  }

  bool get correct => _correct;
  set correct(bool value) {
    _correct = value;
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'correct': correct
    };
  }

  @override
  String toString() {
    return 'Answer{answer: $answer, correct: $correct}';
  }
}