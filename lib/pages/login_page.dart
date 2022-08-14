import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/helpers/sp_global.dart';
import 'package:flutter_codigo5_menuapp/models/user_model.dart';
import 'package:flutter_codigo5_menuapp/pages/register_page.dart';
import 'package:flutter_codigo5_menuapp/services/firestore_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../ui/widgets/button_normal_widget.dart';
import '../ui/widgets/general_widget.dart';
import '../ui/widgets/text_field_password_widget.dart';
import '../ui/widgets/text_field_widget.dart';
import '../ui/widgets/text_widget.dart';
import 'admin/home_admin_page.dart';
import 'customer/init_customer_page.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _txtEmailUsuario = TextEditingController();

  final TextEditingController _txtPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final FirestoreService _userReference =
      FirestoreService(collection: "usuario");

  final SPGlobal _prefs = SPGlobal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);

  void _login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _txtEmailUsuario.text,
        password: _txtPassword.text,
      );
      if (userCredential != null) {
        _userReference.getUser(_txtEmailUsuario.text).then((value) {
          if (value != null) {
            if (value.role == "customer" && value.status) {
              _prefs.role = value.role;
              _prefs.fullName = value.nombre;
              _prefs.email = value.email;
              _prefs.isLogin = true;

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InitCustomerPage(),
                  ),
                  (route) => false);
            } else if (value.role == "admin" && value.status) {
              _prefs.role = value.role;
              _prefs.fullName = value.nombre;
              _prefs.email = value.email;
              _prefs.isLogin = true;

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeAdminPage(),
                  ),
                  (route) => false);
            }
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showSnackBar(context, "El correo electrónico es incorrecto",
            Colors.redAccent, Icons.dangerous);
      } else if (e.code == 'user-not-found') {
        showSnackBar(
            context, "El usuario no existe", Colors.redAccent, Icons.dangerous);
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "La contraseña es incorrecta", Colors.redAccent,
            Icons.dangerous);
      }
    }
  }

  void _loginWithGoogle() async {
    GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();
    if (_googleSignInAccount == null) {
      return;
    }
    GoogleSignInAuthentication _googleSignInAuth =
        await _googleSignInAccount.authentication;

    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: _googleSignInAuth.accessToken,
      idToken: _googleSignInAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.user != null) {
      _userReference
          .getUser(userCredential.user!.email!)
          .then((UserModel? value) {
        if (value == null) {
          UserModel userModel = UserModel(
            nombre: userCredential.user!.displayName!,
            email: userCredential.user!.email!,
            role: "customer",
            status: true,
          );
          _userReference.addUser(userModel).then((value) {
            if (value.isNotEmpty) {
              _prefs.fullName = userModel.nombre;
              _prefs.email = userModel.email;
              _prefs.isLogin = true;
              _prefs.role = userModel.role;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InitCustomerPage(),
                  ),
                  (route) => false);
            }
          });
          print("NO EXISTE");
        } else {
          _prefs.fullName = value.nombre;
          _prefs.email = value.email;
          _prefs.isLogin = true;
          _prefs.role = value.role;

          print(value.role);

          if (value.role == "customer" && value.status) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => InitCustomerPage(),
                ),
                (route) => false);
          } else if (value.role == "admin" && value.status) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeAdminPage(),
                ),
                (route) => false);
          }
        }
      });
    }
  }

  void _loginWithFacebook() async {
    LoginResult _loginResult = await FacebookAuth.instance.login();

    if (_loginResult.status == LoginStatus.success) {
      Map<String, dynamic> userData = await FacebookAuth.instance.getUserData();

      AccessToken accessToken = _loginResult.accessToken!;
      OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        _userReference
            .getUser(userCredential.user!.email!)
            .then((UserModel? value) {
          if (value == null) {
            UserModel userModel = UserModel(
              nombre: userCredential.user!.displayName!,
              email: userCredential.user!.email!,
              role: "customer",
              status: true,
            );
            _userReference.addUser(userModel).then((value) {
              if (value.isNotEmpty) {
                _prefs.fullName = userModel.nombre;
                _prefs.email = userModel.email;
                _prefs.isLogin = true;
                _prefs.role = userModel.role;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InitCustomerPage(),
                    ),
                    (route) => false);
              }
            });
            print("NO EXISTE");
          } else {
            _prefs.fullName = value.nombre;
            _prefs.email = value.email;
            _prefs.isLogin = true;
            _prefs.role = value.role;

            print(value.role);

            if (value.role == "customer" && value.status) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InitCustomerPage(),
                  ),
                  (route) => false);
            } else if (value.role == "admin" && value.status) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeAdminPage(),
                  ),
                  (route) => false);
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SizedBox(),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 22.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          H1(
                            text: "Iniciar Sesión",
                          ),
                          divider3,
                          TextNormal(
                            text: "Por favor ingresa los datos requeridos",
                          ),
                          divider20,
                          TextFieldWidget(
                            hintText: "Correo electrónico",
                            textEditingController: _txtEmailUsuario,
                            validate: true,
                          ),
                          TextFieldPasswordWidget(
                            textEditingController: _txtPassword,
                          ),
                          ButtonNormalWidget(
                            text: "Iniciar Sesión",
                            icon: 'login',
                            onPressed: () {
                              _login();
                            },
                          ),
                          divider12,
                          TextNormal(text: "O puede iniciar sesión con: "),
                          divider3,
                          ButtonNormalWidget(
                            text: "Iniciar sesión con Google",
                            icon: 'google',
                            color: Color(0xffDF4930),
                            onPressed: () {
                              _loginWithGoogle();
                            },
                          ),
                          divider6,
                          ButtonNormalWidget(
                            text: "Iniciar sesión con Facebook",
                            icon: 'facebook',
                            color: Color(0xff507CC0),
                            onPressed: () {
                              _loginWithFacebook();
                            },
                          ),
                          divider12,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextNormal(
                                text: "Aún no tienes una cuenta?",
                              ),
                              dividerWidth6,
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Regístrate",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
