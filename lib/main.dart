import 'dart:convert';

import 'package:esense_quiz/model/listofsets.dart';
import 'package:esense_quiz/model/setofquestions.dart';

import 'package:esense_quiz/screens/newsetform.dart';
import 'package:esense_quiz/screens/playview.dart';
import 'package:esense_quiz/screens/questionview.dart';
import 'package:esense_quiz/screens/setview.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  final JsonStorage storage = JsonStorage();

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<ListOfSets> _sets;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      _sets = widget.storage.readFromJson();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      widget.storage.writeToJson(_sets);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ListOfSets>(
        future: _sets,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              title: 'eSense Earable Quiz',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: MyHomePage(listOfSets: snapshot.data),
              routes: {
                '/newsetform': (context) => NewSetForm(),
                '/setview': (context) => SetView(),
                '/setview/questionview': (context) => QuestionView(),
                '/setview/playview': (context) => PlayView(),
              },
            );
          } else {
            return MaterialApp(
              title: 'eSense Earable Quiz',
              home: Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
              ),
            );
          }
        });
  }
}

class JsonStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final file = File('$path/data.json');
    if (await file.exists()) {
      return file;
    } else {
      return file.create();
    }
  }

  Future<ListOfSets> readFromJson() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      if (contents.isEmpty) {
        return ListOfSets();
      } else {
        Map<String, dynamic> json = jsonDecode(contents);
        return ListOfSets.fromJson(json);
      }
    } catch (e) {
      print(e);
      return ListOfSets();
    }
  }

  Future<File> writeToJson(Future<ListOfSets> sets) async {
    final file = await _localFile;
    String json = jsonEncode(await sets);
    return file.writeAsString(json);
  }
}

class MyHomePage extends StatefulWidget {
  final ListOfSets listOfSets;

  MyHomePage({Key key, @required this.listOfSets}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyHomePageState(listOfSets);
}

class MyHomePageState extends State<MyHomePage> {
  final ListOfSets listOfSets;

  MyHomePageState(this.listOfSets);

  onNewSetPressed(context) {
    Set set = Set();
    setState(() {
      listOfSets.addSet(set);
    });
    Navigator.pushNamed(
        context,
        '/newsetform',
        arguments: set
    );
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: () => Navigator.pushNamed(context, '/setview',
                arguments: listOfSets.sets[index]),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add new set of questions!',
          child: Icon(Icons.add),
          onPressed: () => onNewSetPressed(context),
      ),
    );
  }
}
