

import 'package:esense_flutter/model/question.dart';
import 'package:flutter/foundation.dart';

class Set with ChangeNotifier {
  String _name;
  List<Question> _questions = [];

  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  List<Question> get questions => _questions;
  addQuestion(Question question) {
    _questions.add(question);
    notifyListeners();
  }
  removeQuestion(Question question) {
    _questions.remove(question);
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'questions': questions.map((question) => question.toMap())
    };
  }

  @override
  String toString() {
    return 'Set{name: $name}';
  }
}