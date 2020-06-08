import 'package:flutter/material.dart';
import 'dart:async';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:numberpicker/numberpicker.dart';
//import 'CustomPopupMenu.dart';
//Test from Gabes Laptop
//Test from Brookes Laptop

String tomatoPic = 'images/realistic-tomato-isolated/6146.jpg';

void main() {
  runApp(Mato());
}

class Mato extends StatefulWidget {
  @override
  _MatoState createState() => _MatoState();
}

class _MatoState extends State<Mato> {
  List<Image> completedMato = [];
  bool timerDone = false;
  bool controlTimer = false;
  Timer masterTime;
  double percentComplete = 50;
  // List choices = [
  //   CustomPopupMenu(title: 'Home', icon: Icons.home),
  //   CustomPopupMenu(title: 'Bookmarks', icon: Icons.bookmark),
  //   CustomPopupMenu(title: 'Settings', icon: Icons.settings),
  // ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(
              "Mato Timer",
              style: TextStyle(color: Colors.grey.shade200),
            ),
          ),
          body: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Image.asset(tomatoPic),
                            showTimer(),
                          ],
                        ),
                        Wrap(
                          children: completedMato,
                        ),
                        floatMenu(),
                        RoundedProgressBar(
                          height: 8,
                          theme: RoundedProgressBarTheme.green,
                          style: RoundedProgressBarStyle(
                              borderWidth: 0, widthShadow: 0),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          borderRadius: BorderRadius.circular(24),
                          percent: percentComplete,
                          //childCenter: Text('$percentComplete%', ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showTimer() {
    if (controlTimer == true) {
      masterTimer();

      return myTimer;
    } else {
      if (controlTimer == false) {
        return Text(
          '5 Seconds',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    }
  }

  Widget myTimer = Countdown(
    seconds: 5, //1500 secs = 25 min
    build: (_, double time) => Text(
      time.toString(),
      style: TextStyle(
        fontSize: 72,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    interval: Duration(milliseconds: 100),
    // onFinished: (List<Image> completedMato) {
    //   completedMato.add(Image.asset(tomatoPic));
    //   print(completedMato);
    // }
    onFinished: (masterTime) {
      masterTime.cancel();
    },
  );

  void addTomato() {
    return setState(() {
      completedMato.add(
        Image(
          image: AssetImage(tomatoPic),
          height: 25,
          width: 25,
        ),
      );
      print('Updated Count');
      controlTimer = false;
    });
  }

  void masterTimer() {
    masterTime = new Timer(new Duration(seconds: 5), addTomato);
  }

  Widget floatMenu() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[100],
          width: 2,
        ),
      ),
      //color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
              child: Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  controlTimer = false;
                  masterTime.cancel();
                });
              }),
          // PopupMenuButton(itemBuilder: null)

          PopupMenuButton<int>(
            icon: Icon(
              Icons.apps,
              color: Colors.orange,
            ),
            offset: Offset(-35, -120),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Custom Countdown"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Custom Break"),
              ),
              PopupMenuItem(
                value: 3,
                child: Text("Set Goal"),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  {
                    print("Just set timer");
                    
                      new NumberPickerDialog.decimal(
                        minValue: 1, maxValue: 60, initialDoubleValue: 32,
                        );
                    
                    
                  }
                  break;

                case 2:
                  {
                    print("Just set break");
                  }
                  break;

                case 3:
                  {
                    print("Just set goal");
                  }
                  break;
              }
            },
          ),

          FlatButton(
              child: Icon(Icons.alarm_add, color: Colors.green),
              onPressed: () {
                setState(() {
                  controlTimer = true;
                });
              }),
        ],
      ),
    );
  }


  
}
