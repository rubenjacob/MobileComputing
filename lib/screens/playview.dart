import 'dart:async';
import 'dart:math';
import 'dart:core';

import 'package:dart_numerics/dart_numerics.dart';
import 'package:esense_quiz/model/question.dart';
import 'package:esense_quiz/model/setofquestions.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:esense_flutter/esense.dart';

class PlayView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlayViewState();
}

enum TtsState { playing, stopped }

class PlayViewState extends State<PlayView> {
  List<Question> playlist;
  int current = 0;
  int answered = 0;
  int answeredCorrectly = 0;

  final FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;
  bool get isPlaying => ttsState == TtsState.playing;
  bool _question = false;

  final _deviceName = 'eSense-0830';
  bool _connected = false;
  bool get isConnected => _connected;
  final _samplingRate = 20;
  final _answerTime = 4;
  final _stillThresh = 1;

  @override
  initState() {
    super.initState();
    initTts();
    connectToEsense();
  }

  @override
  dispose() {
    super.dispose();
    flutterTts.stop();
    disconnectFromEsense();
  }

  connectToEsense() async {
    bool connected = await ESenseManager.connect(_deviceName);
    if (connected) {
      setState(() {
        _connected = connected;
      });
      ESenseManager.setSamplingRate(_samplingRate);
    }
  }

  disconnectFromEsense() async {
    bool disconnected = await ESenseManager.disconnect();
  }

  waitForAnswer() async {
    bool connected = await ESenseManager.isConnected();
    if (connected) {
      List<List<int>> acceleration = [];
      StreamSubscription subscription =
          ESenseManager.sensorEvents.listen((event) {
        acceleration.add(event.accel);
      });
      await Future.delayed(Duration(seconds: _answerTime), () {
        subscription.cancel();
      });

      List<List<double>> movement = calculateMovement(acceleration);
      int direction = identifyDirection(movement);

      if (direction == -1) {
        var result =
            await flutterTts.speak('Your answer could not be recognized.');
        if (result == 1) {
          setState(() {
            _question = false;
            ttsState = TtsState.playing;
          });
        }
      } else {
        bool correct = playlist[current].answers[direction].correct;
        String response = correct ? 'That is correct.' : 'That is false.';
        var result = await flutterTts.speak(response);
        if (result == 1) {
          setState(() {
            _question = false;
            ttsState = TtsState.playing;
            answered++;
            if (correct) {
              answeredCorrectly++;
            }
          });
        }
      }
    } else {
      setState(() {
        _connected = false;
      });
    }
  }

  //identify the movement
  List<List<double>> calculateMovement(List<List<int>> accel) {
    List<List<double>> angles =
        accel.map((data) => accelAngles(data[0], data[1], data[2])).toList();

    //calculate bias of inital state from first five measurements
    List<double> initialBias = calculateAverages(angles.sublist(0, 5));

    //find start of the movement
    int startIndex = 0;
    for (int i = 0; i < angles.length - 5; i++) {
      if (!isStill(angles[i], initialBias)) {
        startIndex = i;
        break;
      }
    }

    //find end of the movement
    int endIndex = startIndex + 1;
    outerLoop:
    for (int i = endIndex; i < angles.length; i++) {
      //endIndex is at end of list
      if (i + 5 == angles.length - 1) {
        endIndex = i;
        break outerLoop;
      }

      //find window of 5 measurements that are all similar
      List<List<double>> window = angles.sublist(i, i + 5);
      List<double> averages = calculateAverages(window);
      for (int j = 0; j < 5; j++) {
        if (!isStill(window[j], averages)) {
          continue outerLoop;
        }
      }
      endIndex = i;
      break outerLoop;
    }

    //return part of the input that wasn't still
    return angles.sublist(startIndex, endIndex + 1);
  }

  //identify the direction of the movement
  int identifyDirection(List<List<double>> movement) {
    double zMin = movement[0][2];
    double zMax = movement[0][2];
    int l = movement.length;
    for (int i = 0; i < l; i++) {
      if (movement[i][2] > zMax) {
        zMax = movement[i][2];
      } else if (movement[i][2] < zMin) {
        zMin = movement[i][2];
      }
    }
    //left or right rotation
    if ((zMax - zMin).abs() > 10.0) {
      if (movement[0][2] > movement[l - 1][2]) {
        return 2;
      } else {
        return 3;
      }
    }
    //up or down rotation
    else {
      if (movement[0][0] < movement[l - 1][0] &&
          movement[0][1] > movement[l - 1][1]) {
        return 1;
      } else if (movement[0][0] > movement[l - 1][0] &&
          movement[0][1] < movement[l - 1][1]) {
        return 0;
      } else {
        return -1;
      }
    }
  }

  bool isStill(List<double> angles, List<double> averages) {
    if ((angles[0] - averages[0]).abs() > _stillThresh ||
        (angles[1] - averages[1]).abs() > _stillThresh ||
        (angles[2] - averages[2]).abs() > _stillThresh) {
      return false;
    } else {
      return true;
    }
  }

  List<double> calculateAverages(List<List<double>> data) {
    List<double> sum = [0.0, 0.0, 0.0];
    for (List<double> x in data) {
      sum[0] += x[0];
      sum[1] += x[1];
      sum[2] += x[2];
    }
    double l = data.length.toDouble();
    return [sum[0] / l, sum[1] / l, sum[2] / l];
  }

  //https://engineering.stackexchange.com/questions/3348/calculating-pitch-yaw-and-roll-from-mag-acc-and-gyro-data
  List<double> accelAngles(int ax, int ay, int az) {
    double roll = atan2(ay, sqrt(pow(ax, 2.0) + pow(az, 2.0))) * 180 / pi;
    double pitch = atan2(ax, sqrt(pow(ay, 2.0) + pow(az, 2.0))) * 180 / pi;
    double yaw = atan2(az, sqrt(pow(ax, 2.0) + pow(az, 2.0))) * 180 / pi;
    return [roll, pitch, yaw];
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
      if (_question) {
        waitForAnswer();
      } else if (current < playlist.length - 1) {
        onNextPressed();
        togglePlaying();
      }
    });
    flutterTts.setErrorHandler((error) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
    await flutterTts.setLanguage('en-US');
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.45);
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
          _question = true;
          ttsState = TtsState.playing;
        });
      }
    }
  }

  onNextPressed() async {
    setState(() {
      if (current < playlist.length - 1) {
        current++;
      } else {}
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
      appBar: AppBar(
        title: Text('Playing ${set.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(isConnected ? Icons.check : Icons.cancel),
                Text(isConnected ? 'Connected' : 'Disconnected'),
              ],
            ),
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
            Text('Question ${current + 1}/${playlist.length}'),
            Text('$answeredCorrectly/$answered answered correctly'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: SizedBox(
                height: 380,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.arrow_upward),
                            Text(
                              playlist[current].answers[0].answer,
                              style: TextStyle(height: 1.75, fontSize: 18),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.arrow_downward),
                            Text(
                              playlist[current].answers[1].answer,
                              style: TextStyle(height: 1.75, fontSize: 18),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.arrow_back),
                            Text(
                              playlist[current].answers[2].answer,
                              style: TextStyle(height: 1.75, fontSize: 18),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.arrow_forward),
                            Text(
                              playlist[current].answers[3].answer,
                              style: TextStyle(height: 1.75, fontSize: 18),
                            ),
                          ],
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
