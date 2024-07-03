import 'dart:ui';

import 'package:flutter/material.dart';

import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(const TimeApp());
}

class TimeApp extends StatefulWidget {
  const TimeApp({super.key});

  @override
  State<TimeApp> createState() => _TimeAppState();
}

final ButtonStyle appButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.transparent,
  shadowColor: Colors.transparent,
  side: const BorderSide(
    width: 2.0,
    color: Color.fromRGBO(3, 218, 197, 1),
  ),
);

class _TimeAppState extends State<TimeApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: StartPage(
        toggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }
}

class StartPage extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  const StartPage(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final totalQuestionsController = TextEditingController();
  int selectedTime = 60;

  @override
  void dispose() {
    totalQuestionsController.dispose();
    super.dispose();
  }

  void navigateToTimerPage(BuildContext context) {
    if (totalQuestionsController.text.isEmpty ||
        int.parse(totalQuestionsController.text) > 10000) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: const Text('Empty or too many questions!'),
            actions: <Widget>[
              ElevatedButton(
                style: appButtonStyle,
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color.fromRGBO(3, 218, 197, 1)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    int totalQuestions = int.tryParse(totalQuestionsController.text) ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimerPage(
          totalQuestions: totalQuestions,
          questionTime: selectedTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Time Per Question',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0).withOpacity(0),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0),
                  ),
                  child: SizedBox(
                    height: 15, // Set the desired height here
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                      widget.isDarkMode ? Icons.nights_stay : Icons.wb_sunny),
                  title: widget.isDarkMode
                      ? const Text('Dark Mode')
                      : const Text('Light Mode'),
                  onTap: () {
                    widget.toggleTheme();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: const Text('Report a Bug'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Report a Bug'),
                          content: const Text(
                              'To report a bug, please contact Swapnil Singh at swapnilsingh9056@gmail.com'),
                          actions: <Widget>[
                            ElevatedButton(
                              style: appButtonStyle,
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                    color: Color.fromRGBO(3, 218, 197, 1)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Made by Swapnil Singh'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Made by Swapnil Singh'),
                          content: const Text(
                              'This app was developed by Swapnil Singh.'),
                          actions: <Widget>[
                            ElevatedButton(
                              style: appButtonStyle,
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                  color: Color.fromRGBO(3, 218, 197, 1),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              cursorHeight: 25,
              cursorColor: const Color.fromRGBO(3, 218, 197, 1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
              controller: totalQuestionsController,
              decoration: const InputDecoration(
                labelText: 'Total Questions',
                labelStyle: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(3, 218, 197, 1)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(3, 218, 197, 1),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(3, 218, 197, 1),
                    width: 2,
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<int>(
              value: selectedTime,
              onChanged: (int? newValue) {
                setState(() {
                  selectedTime = newValue!;
                });
              },
              items:
                  <int>[60, 120, 180].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    '${value ~/ 60} min',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            ElevatedButton(
              style: appButtonStyle,
              onPressed: () => navigateToTimerPage(context),
              child: const Text(
                'START',
                style: TextStyle(color: Color.fromRGBO(3, 218, 197, 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerPage extends StatefulWidget {
  final int totalQuestions;
  final int questionTime;

  const TimerPage(
      {super.key, required this.totalQuestions, required this.questionTime});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  List<int> elapsedTimes = [];
  int currentQuestionIndex = 0;
  int remainingTime = 0;
  Timer? timer;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    elapsedTimes = List<int>.filled(widget.totalQuestions, 0);
    remainingTime = widget.questionTime;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (isRunning) {
      return;
    }
    setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          remainingTime--;
        }
        elapsedTimes[currentQuestionIndex] =
            widget.questionTime - remainingTime;
      });
    });
  }

  void stopTimer() {
    if (timer != null) {
      timer?.cancel();
      setState(() {
        isRunning = false;
      });
    }
  }

  void toggleTimer() {
    if (isRunning) {
      stopTimer();
      nextQuestion();
    } else {
      startTimer();
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex < widget.totalQuestions - 1) {
      setState(() {
        currentQuestionIndex++;
        remainingTime =
            widget.questionTime - elapsedTimes[currentQuestionIndex];
      });
    } else {
      showPerformanceDialog();
    }
  }

  void previousQuestion() {
    stopTimer();
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        remainingTime =
            widget.questionTime - elapsedTimes[currentQuestionIndex];
      }
    });
  }

  void showPerformanceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Performance Summary'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.totalQuestions,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Question ${index + 1}'),
                  subtitle: Text('Time Taken: ${elapsedTimes[index]} seconds'),
                );
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: appButtonStyle,
              child: const Text(
                'FINISH',
                style: TextStyle(color: Color.fromRGBO(3, 218, 197, 1)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                finishQuiz();
              },
            ),
          ],
        );
      },
    );
  }

  void finishQuiz() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Time Per Question',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            nextQuestion();
          } else if (details.primaryVelocity! > 0) {
            previousQuestion();
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    '${currentQuestionIndex + 1}/${widget.totalQuestions}',
                    style: const TextStyle(
                        fontSize: 50.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: toggleTimer,
                child: Container(
                  color: const Color.fromARGB(0, 0, 0, 0),
                  child: Center(
                    child: AutoSizeText(
                      '$remainingTime',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.25,
                        color: remainingTime < 0
                            ? Colors.red.shade400
                            : Colors.white,
                      ),
                      maxLines: 1,
                      minFontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: appButtonStyle,
                onPressed: showPerformanceDialog,
                child: const Text(
                  'FINISH',
                  style: TextStyle(
                    color: Color.fromRGBO(3, 218, 197, 1),
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
