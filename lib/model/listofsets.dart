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
    final jsonSets = sets.map((set) => set.toJson()).toList();
    return ({
      'sets': jsonSets
    });
  }

  ListOfSets.fromJson(Map<String, dynamic> json) {
    for (int i = 0; i < json['sets'].length; i++) {
      addSet(Set.fromJson(json['sets'][i]));
    }
  }

}