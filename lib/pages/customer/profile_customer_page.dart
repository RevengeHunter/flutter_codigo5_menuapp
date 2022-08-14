import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/pages/login_page.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../helpers/sp_global.dart';

class ProfileCustomerPage extends StatelessWidget {

  final SPGlobal _prefs = SPGlobal();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _prefs.fullName = "";
              _prefs.email = "";
              _prefs.role = "";
              _prefs.isLogin = false;
              _googleSignIn.signOut();
              FacebookAuth.instance.logOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                      (route) => false);
            },
            child: Text(
              "Cerrar Sesión",
            ),
          ),
        ],
      ),
    );
  }
}
