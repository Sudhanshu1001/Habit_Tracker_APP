import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_tracker/util/habit_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // overall habit summary
  List habitList = [
    // habitName, habitStarted, timeSpent(sec), timeGoal(min)
    ['Exercise', false, 0, 10],
    ['Read', false, 0, 20],
    ['Meditate', false, 0, 20],
    ['Code', false, 0, 40],
  ];
  void habitStarted(int index) {
    //note what the start time is
    var startTime = DateTime.now();

    //include the time already elapsed
    int elapsedTime = habitList[index][2];

    setState(() {
      //habit started or stopped
      habitList[index][1] = !habitList[index][1];
    });

    if (habitList[index][1]) {
      //keep the time going

      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          //check when the user has stopped the timer
          if (habitList[index][1]) {
            timer.cancel();
          }
          //calculate the time elapsed by comparing the time diff
          var currentTime = DateTime.now();
          habitList[index][2] =
          elapsedTime+
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      });
    }
  }

  void settingsOpened(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text('Settings for ' + habitList[index][0]));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Consistency is key.',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          ListView.builder(
            itemCount: habitList.length,
            itemBuilder: ((context, index) {
              return HabitTile(
                habitName: habitList[index][0],
                onTap: () {
                  habitStarted(index);
                },
                habitStarted: habitList[index][1],
                timeSpent: habitList[index][2],
                timeGoal: habitList[index][3],

                settingsTapped: () {
                  settingsOpened(index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
