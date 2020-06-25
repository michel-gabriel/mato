
import 'package:flutter/material.dart';


  dynamic metGoalPopup(context) {
    return showDialog(
      // barrierColor: Colors.white,
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.all(0.0),
        title: Text(
          'CONGRATULATIONS',
          textAlign: TextAlign.center,
        ),
        content: Container(
          // padding: EdgeInsets.zero,
          //  alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  'You completed the goal you set for yourself.',
                  textAlign: TextAlign.center,
                ),
              ),
              RaisedButton(
                  elevation: 25,
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('OK')),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }