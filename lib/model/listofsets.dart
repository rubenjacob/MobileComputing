import 'package:esense_flutter/model/setofquestions.dart';
import 'package:flutter/foundation.dart';

class ListOfSets with ChangeNotifier {
  ListOfSets();

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

  Map<String, dynamic> toJson() {
    return ({
      'sets': sets.map((set) => set.toJson())
    });
  }

  ListOfSets.fromJson(Map<String, dynamic> json) {
    for (int i = 0; i < json['sets']; i++) {
      addSet(Set.fromJson(json['sets'][i]));
    }
  }

}