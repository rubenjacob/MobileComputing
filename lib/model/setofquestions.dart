
import 'package:esense_flutter/model/question.dart';
import 'package:flutter/foundation.dart';

class Set with ChangeNotifier {
  Set();

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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'questions': questions.map((question) => question.toJson())
    };
  }

  Set.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    for (int i = 0; i < json['questions'].length; i++) {
      addQuestion(Question.fromJson(json['questions'][i]));
    }
  }

  @override
  String toString() {
    return 'Set{name: $name}';
  }
}