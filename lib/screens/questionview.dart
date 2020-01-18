import 'package:esense_quiz/model/answer.dart';
import 'package:esense_quiz/model/question.dart';
import 'package:flutter/material.dart';

class QuestionView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  final _formKey = GlobalKey<FormState>();
  final questionController = TextEditingController();
  final answerA = TextEditingController();
  final answerB = TextEditingController();
  final answerC = TextEditingController();
  final answerD = TextEditingController();
  Question _question;

  @override
  Widget build(BuildContext context) {
    _question = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Question'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 344,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: (_question.question != null
                            ? _question.question
                            : 'Enter the question'),
                      ),
                      validator: (value) {
                        if (value.isEmpty && _question.question == null) {
                          return 'Please enter a question.';
                        }
                        return null;
                      },
                      controller: questionController,
                    ),
                    Divider(
                      color: Colors.blue,
                      thickness: 2.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: (_question.answers[0].answer != null
                                    ? _question.answers[0].answer
                                    : 'Answer A')),
                            validator: (value) {
                              if (value.isEmpty &&
                                  _question.answers[0].answer == null) {
                                return 'Please enter an answer.';
                              }
                              return null;
                            },
                            controller: answerA,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.check),
                          tooltip: 'Correct',
                          color: (_question.answers[0].correct
                              ? Colors.green
                              : Colors.black38),
                          onPressed: () {
                            setState(() {
                              _question.answers[0].toggleCorrect();
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: (_question.answers[1].answer != null
                                    ? _question.answers[1].answer
                                    : 'Answer B')),
                            validator: (value) {
                              if (value.isEmpty &&
                                  _question.answers[1].answer == null) {
                                return 'Please enter an answer.';
                              }
                              return null;
                            },
                            controller: answerB,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.check),
                          tooltip: 'Correct',
                          color: (_question.answers[1].correct
                              ? Colors.green
                              : Colors.black38),
                          onPressed: () {
                            setState(() {
                              _question.answers[1].toggleCorrect();
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: (_question.answers[2].answer != null
                                    ? _question.answers[2].answer
                                    : 'Answer C')),
                            validator: (value) {
                              if (value.isEmpty &&
                                  _question.answers[2].answer == null) {
                                return 'Please enter an answer.';
                              }
                              return null;
                            },
                            controller: answerC,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.check),
                          tooltip: 'Correct',
                          color: (_question.answers[2].correct
                              ? Colors.green
                              : Colors.black38),
                          onPressed: () {
                            setState(() {
                              _question.answers[2].toggleCorrect();
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: (_question.answers[3].answer != null
                                    ? _question.answers[3].answer
                                    : 'Answer D')),
                            validator: (value) {
                              if (value.isEmpty &&
                                  _question.answers[3].answer == null) {
                                return 'Please enter an answer.';
                              }
                              return null;
                            },
                            controller: answerD,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.check),
                          tooltip: 'Correct',
                          color: (_question.answers[3].correct
                              ? Colors.green
                              : Colors.black38),
                          onPressed: () {
                            setState(() {
                              _question.answers[3].toggleCorrect();
                            });
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: OutlineButton(
                        child: Text('Save'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (questionController.text.isNotEmpty) {
                              _question.question = questionController.text;
                            }
                            if (answerA.text.isNotEmpty) {
                              _question.answers[0].answer = answerA.text;
                            }
                            if (answerB.text.isNotEmpty) {
                              _question.answers[1].answer = answerB.text;
                            }
                            if (answerC.text.isNotEmpty) {
                              _question.answers[2].answer = answerC.text;
                            }
                            if (answerD.text.isNotEmpty) {
                              _question.answers[3].answer = answerD.text;
                            }
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
