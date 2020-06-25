import 'package:flutter/material.dart';
import 'package:my_mato/infoBox/infoBoxTimeDisplay.dart';
  




  dynamic displayInfoDialog(context, customTime, breakTime, userGoal, tomatoPic ) {
    return showDialog(
      // barrierColor: Colors.green[100],
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.all(0.0),
        content: Container(
          // padding: EdgeInsets.zero,
          //  alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                    '\'Count down\' is the amount of time you want to work for.\n\n\'Break Length\' is the time in between your work sessions.\n\nAs for the \'goal\', you will earn a single tomato for each work session that you complete. This is a way to measure your success.\n'),

                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Count Down: '),
                      displayCorrectTimeForInfoBox(customTime),
                    ]),

                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Break Length: '),
                      displayCorrectTimeForInfoBox(breakTime),
                    ]),

                Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Goal: '),
                      Text('$userGoal',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Image(
                        image: AssetImage(tomatoPic),
                        height: 25,
                        width: 25,
                      ),
                    ]),

                // displayCorrectTime(customTime),
                // displayCorrectTime(breakTime),
                SizedBox(
                  height: 30,
                ),
                OutlineButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Got it',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
