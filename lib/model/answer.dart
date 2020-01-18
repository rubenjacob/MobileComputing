//import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';

//part 'answer.g.dart';

//@JsonSerializable()
class Answer with ChangeNotifier {
  Answer();

  String _answer;
  bool _correct = false;

  String get answer => _answer;
  set answer(String value) {
    _answer = value;
    notifyListeners();
  }

  bool get correct => _correct;
  set correct(bool value) {
    _correct = value;
    notifyListeners();
  }
  toggleCorrect() {
    _correct = !_correct;
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'correct': correct
    };
  }

  Answer.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    correct = json['correct'];
  }

  @override
  String toString() {
    return '$answer';
  }
}