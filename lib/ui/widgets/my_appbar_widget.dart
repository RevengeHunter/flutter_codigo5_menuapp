import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/main.dart';

import '../general/colors.dart';

class MyAppBarWidget extends StatelessWidget {

  String text;
  MyAppBarWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kBrandPrimaryColor,
      title: Text(
        text,
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
          ),
        ),
      ],
    );
  }
}
