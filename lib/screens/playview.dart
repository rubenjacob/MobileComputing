import 'package:esense_quiz/model/question.dart';
import 'package:esense_quiz/model/setofquestions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';

class PlayView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlayViewState();
}

enum TtsState { playing, stopped }

class PlayViewState extends State<PlayView> {
  List<Question> playlist;
  int current = 0;
  final FlutterTts  flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;

  @override
  initState() {
    super.initState();
    initTts();
  }

  @override
  dispose() {
    super.dispose();
    flutterTts.stop();
  }

  Future initTts() async {
    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
    flutterTts.setErrorHandler((error) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
    await flutterTts.setLanguage('en-US');
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.25);
    await flutterTts.setPitch(1.0);
  }

  List _shuffle(List items) {
    var random = new Random();
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  togglePlaying() async {
    if (isPlaying) {
      var result = await flutterTts.stop();
      if (result == 1) {
        setState(() {
          ttsState = TtsState.stopped;
        });
      }
    } else {
      var result = await flutterTts.speak(playlist[current].toString());
      if (result == 1) {
        setState(() {
          ttsState = TtsState.playing;
        });
      }
    }
  }

  onNextPressed() async {
    setState(() {
      if (current < playlist.length - 1) {
        current++;
      }
    });
  }

  onPreviousPressed() async {
    setState(() {
      if (current > 0) {
        current--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Set set = ModalRoute.of(context).settings.arguments;
    setState(() {
      playlist = set.questions;
    });


    return Scaffold(
      appBar: AppBar(title: Text('Playing ${set.name}'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.fast_rewind),
                  iconSize: 48,
                  onPressed: onPreviousPressed,
                ),
                IconButton(
                  icon: (isPlaying
                    ? Icon(Icons.stop)
                    : Icon(Icons.play_circle_filled)),
                  iconSize: 72,
                  onPressed: togglePlaying,
                ),
                IconButton(
                  icon: Icon(Icons.fast_forward),
                  iconSize: 48,
                  onPressed: onNextPressed,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: SizedBox(
                height: 400,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          playlist[current].question,
                          style: TextStyle(height: 1.75, fontSize: 24),
                        ),
                        Divider(
                          thickness: 2.0,
                          color: Colors.blue,
                        ),
                        Text(
                          'a) ' + playlist[current].answers[0].answer,
                          style: TextStyle(height: 1.75, fontSize: 18),
                        ),
                        Divider(),
                        Text(
                          'b) ' + playlist[current].answers[1].answer,
                          style: TextStyle(height: 1.75, fontSize: 18),
                        ),
                        Divider(),
                        Text(
                          'c) ' + playlist[current].answers[2].answer,
                          style: TextStyle(height: 1.75, fontSize: 18),
                        ),
                        Divider(),
                        Text(
                          'd) ' + playlist[current].answers[3].answer,
                          style: TextStyle(height: 1.75, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}