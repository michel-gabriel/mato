
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

  dynamic breakPopup(context, breakTime) {
    showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.all(0.0),
        content: Container(
          // padding: EdgeInsets.zero,
          //  alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                // value: breakTimer,

                backgroundColor: Colors.green[100],
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Nice work, now take a break',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  'We will remind you when it is time to get back to work.',
                  textAlign: TextAlign.center,
                ),
              ),
              Countdown(
                seconds: breakTime, //1500 secs = 25 min
                build: (_, double breakTime) => Text(
                  breakTime.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                interval: Duration(seconds: 1),

                onFinished: () {
                  Navigator.pop(context, false);
                },
              ),
              RaisedButton(
                  elevation: 25,
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('I don\'t take breaks!')),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }