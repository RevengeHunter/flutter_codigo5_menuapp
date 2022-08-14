import 'package:flutter/material.dart';

import '../general/colors.dart';
import '../general/fonts.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight? fontWeight;
  final double? height;
  final int? maxLines;
  final TextOverflow? textOverflow;

  TextWidget({
    required this.text,
    required this.fontSize,
    required this.color,
    this.fontWeight,
    this.height,
    this.maxLines,
    this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: textOverflow,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

class H1 extends StatelessWidget {
  final String text;

  H1({required this.text});

  @override
  Widget build(BuildContext context) {
    return TextWidget(
      text: text,
      fontSize: kH1Size,
      color: kBrandPrimaryColor,
      fontWeight: FontWeight.w600,
      height: 1.1,
    );
  }
}

class TextNormal extends StatelessWidget {
  final String text;
  final Color? color;
  final int? maxLines;
  final TextOverflow? textOverflow;

  TextNormal({required this.text, this.color, this.maxLines, this.textOverflow});

  @override
  Widget build(BuildContext context) {
    return TextWidget(
      text: text,
      textOverflow: textOverflow,
      maxLines: maxLines,
      fontSize: kTextNormalSize,
      color: color ?? kBrandPrimaryColor,
    );
  }
}
