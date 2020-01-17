import 'package:esense_flutter/model/answer.dart';
import 'package:esense_flutter/model/setofquestions.dart';
import 'package:esense_flutter/model/question.dart';
import 'package:flutter/material.dart';

class SetView extends StatelessWidget {

  onNewQuestionTapped(context, set) {
    Question question = Question();
    set.addQuestion(question);
    question.addAnswer(Answer());
    question.addAnswer(Answer());
    question.addAnswer(Answer());
    question.addAnswer(Answer());
    Navigator.pushNamed(
        context,
        '/setview/questionview',
        arguments: question
    );
  }

  @override
  Widget build(BuildContext context) {
    final Set set = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('${set.name}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.play_arrow),
            iconSize: 36.0,
            onPressed: () => Navigator.pushNamed(
                context,
                '/setview/playview',
                arguments: set
            ),
          )
        ],
      ),
      body: Center(
        child: ListView.builder(
            itemCount: set.questions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${set.questions[index].question}'),
                onTap: () => Navigator.pushNamed(
                    context,
                    '/setview/questionview',
                    arguments: set.questions[index]
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add a new question!',
        child: Icon(Icons.add),
        onPressed: () => onNewQuestionTapped(context, set),
      ),
    );
  }
}