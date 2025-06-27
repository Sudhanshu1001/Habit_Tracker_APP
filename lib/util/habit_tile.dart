import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final VoidCallback onTap;
  final VoidCallback settingsTapped;
  final int timeSpent;
  final int timeGoal;
  final bool habitStarted;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.onTap,
    required this.habitStarted,
    required this.settingsTapped,
    required this.timeSpent,
    required this.timeGoal,
  });

  //convert seconds into min:sec
  String formatToMinSec(int totalSeconds) {
    String secs = (totalSeconds % 60).toString();
    String mins = (totalSeconds / 60).toStringAsFixed(5);

    // if secs is a 1 digit number, place  a 0 infront of it
    if (secs.length == 1) {
      secs = '0' + secs;
    }

    //if mins is a 1 digit number
    if (mins[1] == '.') {
      mins = mins.substring(0, 1);
    }
    return mins + ':' + secs;
  }

  //calculate progress indicator percentage
  double percentCompleted() {
    return timeSpent / (timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 10.0,
        bottom: 10,
      ),
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //progress circle
            Row(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Stack(
                      children: [
                        //progress indicator
                        CircularPercentIndicator(
                          radius: 30, // Changed from 60 to 30
                          percent: percentCompleted()<1? percentCompleted():1,
                          progressColor:percentCompleted()>0.7? Colors.green:Colors.redAccent,

                          lineWidth:6
                          , // Reduced line width for better proportion
                          animation: true,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),

                        // play pause button
                        Center(
                          child: Icon(
                            habitStarted ? Icons.pause : Icons.play_arrow,
                            size: 20, // Reduced icon size for better fit
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20.0),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //habit name
                    Text(
                      habitName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 5.0),

                    //habit progress
                    Text(
                      formatToMinSec(timeSpent) + '/' + timeGoal.toString()+
                      ' = '+ 
                      (percentCompleted()*100).toStringAsFixed(0)+'%',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(onTap: settingsTapped, child: Icon(Icons.settings)),
          ],
        ),
      ),
    );
  }
}
