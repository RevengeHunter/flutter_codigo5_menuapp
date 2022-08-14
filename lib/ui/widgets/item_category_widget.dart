import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../general/colors.dart';
import 'general_widget.dart';

class ItemCategoryWidget extends StatelessWidget {

  String text;
  bool selected;
  Function onTap;

  ItemCategoryWidget({ required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20.0),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold: FontWeight.normal,
                color: selected ? kBrandPrimaryColor : kBrandPrimaryColor.withOpacity(0.6),
              ),
            ),
            divider6,
            selected ? Container(
              width: 20,
              height: 4,
              decoration: BoxDecoration(
                color: kBrandSecondaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ) :  SizedBox(),
          ],
        ),
      ),
    );
  }
}
