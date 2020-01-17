import 'package:esense_flutter/model/listofsets.dart';
import 'package:esense_flutter/model/setofquestions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewSetForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final listOfSets = Provider.of<ListOfSets>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Enter a name')),
        body: Center(
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a name.';
                          }
                          return null;
                        },
                        controller: textController,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              final set = Set();
                              set.name = textController.text;
                              listOfSets.addSet(set);
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Add'),
                        ))
                  ],
                ))));
  }
}
