import 'package:esense_flutter/model/setofquestions.dart';
import 'package:flutter/foundation.dart';

class ListOfSets with ChangeNotifier {
  List<Set> _sets = [];

  List<Set> get sets => _sets;
  addSet(Set set) {
    _sets.add(set);
    notifyListeners();
  }
  removeSet(Set set) {
    _sets.remove(set);
    notifyListeners();
  }

}