import 'package:flutter/material.dart';
import 'dart:async';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_picker/flutter_picker.dart';
//import 'CustomPopupMenu.dart';
//Test from Gabes Laptop
//Test from Brookes Laptop IT WORKED.

String tomatoPic = 'images/realistic-tomato-isolated/6146.jpg';

void main() {
  runApp(MaterialApp(
      home:
          Mato())); // Wrap main app in materialapp if you recieve localization problems from gesture.
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
  double percentComplete = 0;
  int customTime = 2; // change this for default countdown
  int tempInt = 0;
  int tomatoQuantity = 0;
  int userGoal = 2;
  int breakTime = 5;

  // List choices = [
  //   CustomPopupMenu(title: 'Home', icon: Icons.home),
  //   CustomPopupMenu(title: 'Bookmarks', icon: Icons.bookmark),
  //   CustomPopupMenu(title: 'Settings', icon: Icons.settings),
  // ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed:(){
              displayInfoDialog();
            },
          child: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),),
          title: Text(
            "Mato Timer",
            style: TextStyle(color: Colors.grey.shade200),
          ),
        ),
        body: SafeArea(
          child: Container(
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
                        Container(

                            child: Column(
                            
                              children: <Widget>[
                                floatMenu(),
                          RoundedProgressBar(
                            height: 8,
                            
                            theme: RoundedProgressBarTheme.green,
                            style: RoundedProgressBarStyle(
                                borderWidth: 0, widthShadow: 0),
                           // margin: EdgeInsets.symmetric(vertical: 10),
                            borderRadius: BorderRadius.circular(24),
                            percent: percentComplete,
                            childCenter: Text(
                              '$tomatoQuantity/$userGoal',
                              style: TextStyle(
                                  fontSize: 8.5, fontWeight: FontWeight.bold),
                            ),
                            //childCenter: Text('$percentComplete%', ),
                          ),
                          
                        ])),
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

      return myTimer();
    } else {
      if (controlTimer == false) {
        return Text(
          '$customTime Seconds',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    }
  }

  Widget myTimer() {
    return Countdown(
      seconds: customTime, //1500 secs = 25 min
      build: (_, customTime) => Text(
        customTime.toString(),
        style: TextStyle(
          fontSize: 72,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      interval: Duration(milliseconds: 100),

      onFinished: (masterTime) {
        masterTime.cancel();
      },
    );
  }

  void addTomato() {
    return setState(() {
      completedMato.add(
        Image(
          image: AssetImage(tomatoPic),
          height: 25,
          width: 25,
        ),
      );
      ++tomatoQuantity;
      percentComplete = (tomatoQuantity / userGoal) * 100;

      print(percentComplete);
      print('Updated Count');
      controlTimer = false;
      breakPopup();
    });
  }

  void masterTimer() {
    masterTime = new Timer(new Duration(seconds: customTime), addTomato);
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
              onLongPress: () {
                setState(() {
                  completedMato.clear();
                  percentComplete = 0;
                  tomatoQuantity = 0;
                  customTime = 1500;
                  masterTime.cancel();
                  userGoal = 2;
                  breakTime = 5;
                });
              },
              onPressed: () {
                setState(() {
                  controlTimer = false;
                  masterTime.cancel();
                });
              }),
          PopupMenuButton<int>(
            icon: Icon(
              Icons.apps,
              color: Colors.orange,
            ),
            offset: Offset(-90, -160),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Set Custom Countdown", ),
                
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Set Custom Break", ),
              ),
              PopupMenuItem(
                value: 3,
                child: Text("Set Custom Goal", ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  {
                    print("Just set timer");

                    Picker(
                        adapter: NumberPickerAdapter(data: [
                          NumberPickerColumn(begin: 0, end: 12),
                          NumberPickerColumn(begin: 0, end: 59),
                        ]),
                        delimiter: [
                          PickerDelimiter(
                              child: Container(
                            width: 80.0,
                            alignment: Alignment.center,
                            child: Text('Hr | Mn'),
                          ))
                        ],
                        hideHeader: true,
                        title: new Text("Select Hours and Minutes"),
                        onConfirm: (Picker picker, List value) {
                          tempInt = value[0] * 60;
                          tempInt += value[1];

                          setState(() {
                            customTime = tempInt;
                            controlTimer = false;
                            tomatoQuantity = 0;
                            userGoal = 0;
                            completedMato.clear();
                          });
                        }).showDialog(context);
                  }
                  break;

                case 2:
                  {
                    print("Just set break");

                    Picker(
                        adapter: NumberPickerAdapter(data: [
                          NumberPickerColumn(begin: 1, end: 59),
                        ]),
                        delimiter: [
                          PickerDelimiter(
                              child: Container(
                            width: 80.0,
                            alignment: Alignment.center,
                            child: Text('Minutes'),
                          ))
                        ],
                        hideHeader: true,
                        title: new Text("Select Minutes"),
                        onConfirm: (Picker picker, List value) {
                          setState(() {
                            breakTime = ++value[0];
                          });

                          //   Timer(new Duration(seconds: customTime), finishedGoal); //Might have to move this.
                        }).showDialog(context);
                  }
                  break;

                case 3:
                  {
                    print("Just set goal");

                    Picker(
                        adapter: NumberPickerAdapter(data: [
                          NumberPickerColumn(begin: 1, end: 100),
                        ]),
                        delimiter: [
                          PickerDelimiter(
                              child: Container(
                            width: 80.0,
                            alignment: Alignment.center,
                            child: Image(
                              image: AssetImage(tomatoPic),
                              height: 25,
                              width: 25,
                            ),
                          ))
                        ],
                        hideHeader: true,
                        looping: true,
                        title: new Text("Select a Goal"),
                        onConfirm: (Picker picker, List value) {
                          print(value[0]);
                          setState(() {
                            percentComplete = 0;
                            tomatoQuantity = 0;

                            userGoal = value[0] + 1;
                            completedMato.clear();
                          });
                        }).showDialog(context);
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

  dynamic breakPopup() {
    showDialog(
      barrierColor: Colors.green[100],
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
                  Navigator.pop(context, true);
                },
              ),
              RaisedButton(
                  elevation: 25,
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('I don\'t take breaks!')),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  dynamic displayInfoDialog(){
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
                
                Text('Information',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                SizedBox(height: 30,),
                Text('\'Count down\' is the amount of time you want to work for.\n\n\'Break Length\' is the time in between your work sessions.\n\nAs for the \'goal\', you will earn a single tomato for each work session that you complete. This is a way to measure your success.\n'),
                Text('Count Down: $customTime minutes\nBreak Length: $breakTime minutes\nGoal: $userGoal tomatoes '),
                SizedBox(height: 30,),
                OutlineButton(onPressed: (){
                  Navigator.pop(context, true);
                }, child: Text('Got it', style: TextStyle(fontWeight: FontWeight.bold)),),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }


}
