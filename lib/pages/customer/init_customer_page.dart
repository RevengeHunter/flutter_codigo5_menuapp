import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/pages/customer/home_customer_page.dart';
import 'package:flutter_codigo5_menuapp/pages/customer/profile_customer_page.dart';
import 'package:flutter_codigo5_menuapp/services/order_stream_service.dart';
import 'package:flutter_codigo5_menuapp/ui/general/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'order_customer_page.dart';

class InitCustomerPage extends StatefulWidget {
  const InitCustomerPage({Key? key}) : super(key: key);

  @override
  State<InitCustomerPage> createState() => _InitCustomerPageState();
}

class _InitCustomerPageState extends State<InitCustomerPage> {
  int _currentIndex = 0;
  List<Widget> _pages = [
    HomeCustomerPage(),
    OrderPage(),
    Center(
      child: Text(
        "Favoritos",
      ),
    ),
    ProfileCustomerPage(),
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    OrderStreamService().closeStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 13.0,
        ),
        selectedFontSize: 13.0,
        unselectedFontSize: 11.0,
        selectedItemColor: kBrandSecondaryColor,
        unselectedItemColor: kBrandPrimaryColor.withOpacity(0.8),
        currentIndex: _currentIndex,
        onTap: (int value) {
          _currentIndex = value;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            label: "Inicio",
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              color: _currentIndex == 0
                  ? kBrandSecondaryColor
                  : kBrandPrimaryColor.withOpacity(0.8),
            ),
          ),
          BottomNavigationBarItem(
            label: "Ordenes",
            icon: Stack(
              clipBehavior: Clip.none,
              //fit: StackFit.loose,
              children: [
                SvgPicture.asset(
                  'assets/icons/shopping.svg',
                  color: _currentIndex == 1
                      ? kBrandSecondaryColor
                      : kBrandPrimaryColor.withOpacity(0.8),
                ),
                Positioned(
                  right: -6,
                  top: -7,
                  child: StreamBuilder(
                    stream: OrderStreamService().counterStream,
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      if (snap.hasData) {
                        int counter = snap.data;
                        return counter > 0 ? Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: kBrandSecondaryColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            counter.toString(),
                            style: const TextStyle(
                              fontSize: 11.0,
                            ),
                          ),
                        ) : SizedBox();
                      }
                      return SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            label: "Favoritos",
            icon: SvgPicture.asset(
              'assets/icons/heart.svg',
              color: _currentIndex == 2
                  ? kBrandSecondaryColor
                  : kBrandPrimaryColor.withOpacity(0.8),
            ),
          ),
          BottomNavigationBarItem(
            label: "Mi perfil",
            icon: SvgPicture.asset(
              'assets/icons/user.svg',
              color: _currentIndex == 3
                  ? kBrandSecondaryColor
                  : kBrandPrimaryColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
