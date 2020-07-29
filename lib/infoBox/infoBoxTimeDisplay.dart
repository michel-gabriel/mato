import 'package:flutter/material.dart';



Widget displayCorrectTimeForInfoBox(int countdown) {
    if (countdown == 0) {
      return Text(
        '$countdown',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    if (countdown < 60 && countdown > 0) {
      return Text(
        '$countdown seconds',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    if (60 <= countdown && countdown < 3600) {
      // double secondz = (countdown%60).toDouble();
      int minutez = (countdown ~/ 60).toInt();

      if (minutez == 1) {
        return Text(
          '$minutez minute',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        return Text(
          '$minutez minutes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      }
    }
    if (3600 <= countdown) {
      int minutez1 = (countdown % 3600);
      int hourz = (countdown ~/ 3600).toInt();
      int minutez2 = (minutez1 ~/ 60).toInt();

      if (hourz == 1 && minutez2 == 0) {
        return Text(
          '$hourz hour',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      }

      if (minutez2 == 0 && hourz > 1) {
        return Text(
          '$hourz hours',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      } 
      if (minutez2 > 0 && minutez2 < 10 && hourz > 1) {
        return Text(
          '$hourz:0$minutez2',
          style: TextStyle(
           
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        return Text(
          '$hourz:$minutez2',
          style: TextStyle(
            
            fontWeight: FontWeight.bold,
          ),
        );
      }
      
    }
  }