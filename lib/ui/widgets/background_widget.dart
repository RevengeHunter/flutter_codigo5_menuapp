import 'dart:math';

import 'package:flutter/material.dart';

import '../general/colors.dart';
import 'general_widget.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Stack(
      //fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -height * 0.2,
          left: -height * 0.075,
          child: Transform.rotate(
            angle: pi / 4.1,
            child: Container(
              height: height * 0.6,
              width: height * 0.6,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(220.0),
                gradient: LinearGradient(
                  colors: [
                    kBrandSecondaryColor,
                    Color(0xff2ec4b6),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: -40.0,
          top: -10.0,
          child: circleWidget(100.0),
        ),
        Positioned(
          right: -width * 0.22,
          top: 10.0,
          child: circleWidget(120.0),
        ),
      ],
    );
  }
}
