import 'package:esense_flutter/model/setofquestions.dart';
import 'package:flutter/material.dart';

class PlayView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Set set = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text('Playing ${set.name}'),),
      body: Text('ToDo...'),
    );
  }

}