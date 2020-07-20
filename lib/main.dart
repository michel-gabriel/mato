import 'package:flutter/material.dart';
import 'package:my_mato/notifications/message.dart';
import 'dart:async';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_mato/popUps/breakPopupDialog.dart';
import 'package:my_mato/popUps/metGoalPopupDialog.dart';
import 'package:my_mato/infoBox/displayInfoBox.dart';
import 'package:my_mato/notifications/notificationWidget.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:my_mato/timeWidgets/formatDisplayTime.dart';
import 'package:timer_count_down/timer_count_down.dart';

String tomatoPic = 'images/realistic-tomato-isolated/6146.jpg';
const String testDevice = 'Mobile_ID'; //af1be50a6c49c952

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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['Timer', 'Countdown'],
  );

  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId:
            BannerAd.testAdUnitId /*'ca-app-pub-2770950394919073/4234856034'*/,
        size: AdSize.banner, //change size of banner
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print('Banner Ad $event');
        });
  }

  List<Image> completedMato = [];
  bool timerDone = false;
  bool controlTimer = false;
  Timer masterTime;

  Timer thirtySecondNotify;
  Timer thirtySecondNotifyBreak;
  double percentComplete = 0;
  int customTime = 3; // change this for default countdown
  int tempInt = 0;
  int tomatoQuantity = 0;
  int userGoal = 3;
  int breakTime = 5;
  bool timerActive = false;

  @override
  void initState() {
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('p6146_copy');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            displayInfoDialog(context, customTime, breakTime, userGoal,
                tomatoPic) /* onSelectNotification(payload)*/);

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: null /*onSelectNotification*/);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // final notification = message['notification'];
        // setState(() {
        //   messages.add(Message(
        //       title: notification['title'], body: notification['body']));
        // });
        //
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //block of code will execute when app is killed/not running and notification is tapped
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //this block of code will be executed when app is running but not open and notification is tapped
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-2770950394919073~9617925096');
    _bannerAd = createBannerAd()
      ..load()
      ..show();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
  //Both these widgets below are on tap local notification reaction and to display notification on screen.
  // Future onSelectNotification(String payload) async => await Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => displayInfoDialog(context, customTime, breakTime, userGoal, tomatoPic)),
  //     );

  // Widget buildMessage(Messagez message) => ListTile(
  //       title: Text(message.title),
  //       subtitle: Text(message.body),
  //     );

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              displayInfoDialog(
                  context, customTime, breakTime, userGoal, tomatoPic);
            },
            child: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
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
                            child: Column(children: <Widget>[
                          // RaisedButton(
                          //   onPressed: () => showOngoingNotification(
                          //       notifications,
                          //       title: 'Title',
                          //       body: 'Body'),
                          //   child: Text('Notifications'),
                          // ),
                          // RaisedButton(
                          //     onPressed: notifications.cancelAll,
                          //     child: Text('Cancel Notifications')),
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
                          SizedBox(height: 50),
                        ])),
                        // ListView(
                        //   children: messages.map(buildMessage).toList(),
                        // ),
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
      if (!timerActive) (masterTimer());
      //  print('Timer tick is: ${masterTime.tick}');

      return myTimer();
    } else {
      if (controlTimer == false) {
        return displayCorrectTime(customTime);
        // return Text(
        //   '$customTime Seconds',
        //   style: TextStyle(
        //     fontSize: 40,
        //     color: Colors.white,
        //     fontWeight: FontWeight.bold,
        //   ),
        // );
      }
    }
  }

  Widget myTimer() {
    timerActive = true;
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

      onFinished: () {
        //  masterTime.cancel();
        print('MADE IT');
        setState(() {
          print('MADE IT x2');
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

          if (tomatoQuantity == userGoal) {
            metGoalPopup(context);
          } else {
            breakPopup(context, breakTime);
            breakMasterTime();
          }
        });
      },
    );
  }

  // void addTomato() {
  //   return setState(() {
  //     completedMato.add(
  //       Image(
  //         image: AssetImage(tomatoPic),
  //         height: 25,
  //         width: 25,
  //       ),
  //     );
  //     ++tomatoQuantity;
  //     percentComplete = (tomatoQuantity / userGoal) * 100;

  //     print(percentComplete);
  //     print('Updated Count');
  //     controlTimer = false;

  //     if (tomatoQuantity == userGoal) {
  //       metGoalPopup(context);
  //     } else {
  //       breakPopup(context, breakTime);
  //       breakMasterTime();
  //     }
  //   });
  // }

  dynamic masterTimer() {
    // masterTime = new Timer(new Duration(seconds: customTime), addTomato);

    thirtySecondNotify =
        new Timer(new Duration(seconds: (customTime - 30)), showNotification);
  }

  dynamic breakMasterTime() {
    thirtySecondNotifyBreak = new Timer(
        new Duration(seconds: (breakTime - 30)), showBreakNotification);
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
                  if (timerActive) {
                    thirtySecondNotify.cancel();
                    thirtySecondNotifyBreak.cancel();
                  }
                  customTime = 1500;
                  completedMato.clear();
                  percentComplete = 0;
                  tomatoQuantity = 0;
                  controlTimer = false;
                  timerActive = false;
                  userGoal = 3;
                  breakTime = 300;
                });

                // masterTime.cancel();
              },
              onPressed: () {
                // getID();
                setState(() {
                  if (timerActive) {
                    thirtySecondNotify.cancel();
                    thirtySecondNotifyBreak.cancel();
                  }
                  controlTimer = false;
                  timerActive = false;

                  // masterTime.cancel();
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
                child: Text(
                  "Set Custom Countdown",
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  "Set Custom Break",
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Text(
                  "Set Custom Goal",
                ),
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
                          tempInt = value[0] * 3600;
                          tempInt = tempInt + (value[1] * 60);
                          print(
                              'minutes chosen: ${value[1]} , hours chosen: ${value[0]} \n');

                          timerActive = false;
                          setState(() {
                            if (timerActive) {
                              thirtySecondNotify.cancel();
                            }

                            print('Custom Timer setSt worked.');
                            customTime = tempInt;
                            controlTimer = false;

                            tomatoQuantity = 0;
                            // userGoal = 2;
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
                            breakTime = ++value[0] * 60;

                            //controlTimer = false;
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

                            //  masterTime.cancel();
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
}
