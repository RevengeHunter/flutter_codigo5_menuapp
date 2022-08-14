import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../general/colors.dart';
const divider3 = SizedBox(height: 3.0,);
const divider6 = SizedBox(height: 6.0,);
const divider12 = SizedBox(height: 12.0,);
const divider20 = SizedBox(height: 20.0,);
const divider30 = SizedBox(height: 30.0,);
const divider40 = SizedBox(height: 40.0,);

const dividerWidth3 = SizedBox(
  width: 3.0,
);

const dividerWidth6 = SizedBox(
  width: 6.0,
);

const dividerWidth10 = SizedBox(
  width: 10.0,
);

const dividerWidth20 = SizedBox(
  width: 20.0,
);

Widget circleWidget(double radius) {
  return Container(
    height: radius * 2,
    width: radius * 2,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(0.13),
    ),
  );
}

Widget loadingWidget(){
  return const Center(
    child: SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: kBrandSecondaryColor,
      ),
    ),
  );
}

void showSnackBar(BuildContext context, String text, Color color, IconData icons){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: color,//Colors.redAccent,
      content: Row(
        children: [
          Icon(icons,color: Colors.white,),
          dividerWidth10,
          Text(
            text,
          ),
        ]
      ),
    ),
  );
}