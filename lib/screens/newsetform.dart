import 'package:esense_quiz/model/setofquestions.dart';
import 'package:flutter/material.dart';

class NewSetForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewSetFormState();
}

class NewSetFormState extends State<NewSetForm> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Set _set = ModalRoute.of(context).settings.arguments;
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
                              _set.name = textController.text;
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Add'),
                        ))
                  ],
                ))));
  }
}
