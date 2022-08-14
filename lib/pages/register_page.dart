import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/helpers/sp_global.dart';
import 'package:flutter_codigo5_menuapp/models/user_model.dart';
import 'package:flutter_codigo5_menuapp/pages/customer/home_customer_page.dart';
import 'package:flutter_codigo5_menuapp/services/firestore_service.dart';
import 'package:flutter_codigo5_menuapp/ui/general/colors.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/general_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_field_widget.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_widget.dart';

import '../ui/widgets/button_normal_widget.dart';
import '../ui/widgets/text_field_password_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _txtEmailUsuario = TextEditingController();

  final TextEditingController _txtNombres = TextEditingController();

  final TextEditingController _txtPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final FirestoreService _userFirestoreService =
      FirestoreService(collection: 'usuario');

  final SPGlobal _prefs = SPGlobal();

  bool isLoading = false;

  registerCustomer() async {
    if (_formKey.currentState!.validate()) {
      try {

        isLoading = true;
        setState((){});

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _txtEmailUsuario.text,
          password: _txtPassword.text,
        );
        print(userCredential.user);

        if (userCredential.user != null) {
          UserModel userModel = UserModel(
              role: "customer",
              status: true,
              email: _txtEmailUsuario.text,
              nombre: _txtNombres.text);
          _userFirestoreService.addUser(userModel).then((value) {
            if (value.isNotEmpty) {
              _prefs.fullName = userModel.nombre;
              _prefs.email = userModel.email;
              _prefs.isLogin = true;
              _prefs.role = userModel.role;

              isLoading = false;
              setState((){});

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: Colors.green,
                  content: const Text(
                    "El registro se realizo con exito",
                  ),
                ),
              );

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeCustomerPage()),
                  (route) => false);
            }
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == "email-already-in-use") {
          showSnackBar(context, "El correo electrónico ya está registrado",Colors.redAccent,Icons.dangerous);
        } else if (e.code == "weak-password") {
          showSnackBar(context, "La contraseña es débil, intenta con otra",Colors.redAccent,Icons.dangerous);
        }
        isLoading = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: kBrandPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 22.0,
                        horizontal: 20.0,
                      ),
                      decoration: const BoxDecoration(
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
                                text: "Regístrate",
                              ),
                              divider3,
                              TextNormal(
                                text: "Por favor ingresa los datos requeridos",
                              ),
                              divider20,
                              TextFieldWidget(
                                hintText: "Nombres",
                                textEditingController: _txtNombres,
                                validate: true,
                              ),
                              TextFieldWidget(
                                hintText: "Correo electrónico",
                                textEditingController: _txtEmailUsuario,
                                validate: true,
                              ),
                              TextFieldPasswordWidget(
                                textEditingController: _txtPassword,
                              ),
                              ButtonNormalWidget(
                                text: "Registrar",
                                icon: 'happy',
                                onPressed: () {
                                  registerCustomer();
                                },
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
          isLoading ? Container(
            color: Colors.white.withOpacity(0.8),
            child: loadingWidget(),
          ) : Container(),
        ],
      ),
    );
  }
}
