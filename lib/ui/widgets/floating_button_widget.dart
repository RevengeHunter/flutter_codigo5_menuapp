import 'package:flutter/material.dart';

import '../general/colors.dart';
import 'general_widget.dart';

class FloatingButtonWidget extends StatelessWidget {

  Function onTap;
  FloatingButtonWidget({required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: kBrandPrimaryColor,
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            dividerWidth6,
            Text(
              "Agregar",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
