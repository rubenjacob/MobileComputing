import 'package:esense_flutter/model/listofsets.dart';
import 'package:esense_flutter/model/question.dart';
import 'package:esense_flutter/model/setofquestions.dart';
import 'package:esense_flutter/screens/newsetform.dart';
import 'package:esense_flutter/screens/playview.dart';
import 'package:esense_flutter/screens/questionview.dart';
import 'package:esense_flutter/screens/setview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListOfSets>(
        create: (context) => ListOfSets(),
        child: MaterialApp(
          title: 'eSense Earable Quiz',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(),
          routes: {
            '/newsetform': (context) => NewSetForm(),
            '/setview': (context) => SetView(),
            '/setview/questionview': (context) => QuestionView(),
            '/setview/playview': (context) => PlayView(),
          },
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final listOfSets = Provider.of<ListOfSets>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('eSense Earable Quiz'),
      ),
      body: Center(
          child: ListView.builder(
        itemCount: listOfSets.sets.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${listOfSets.sets[index].name}'),
            onTap: () => Navigator.pushNamed(
                context,
                '/setview',
                arguments: listOfSets.sets[index]
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add new set of questions!',
          child: Icon(Icons.add),
          onPressed: () => Navigator.pushNamed(context, '/newsetform')),
    );
  }
}
