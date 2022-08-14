import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../general/colors.dart';
import '../general/fonts.dart';
import 'general_widget.dart';

class SearchWidget extends StatelessWidget {

  Function onTap;
  SearchWidget({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.black.withOpacity(0.04),
      splashColor: Colors.black.withOpacity(0.04),
      onTap: (){
        onTap();
      },
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12.0,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: TextField(
                onTap: () {
                  onTap();
                },
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Buscar Productos",
                  hintStyle: TextStyle(
                    fontSize: kTextNormalSize,
                    color: kBrandPrimaryColor.withOpacity(0.6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          dividerWidth10,
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              color: kBrandSecondaryColor,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kBrandSecondaryColor,
                  Color(0xff04FE86),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12.0,
                  offset: Offset(4,4),
                ),
              ],
            ),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              color: Colors.white,
              height: 24,
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
      ),
    );
  }
}