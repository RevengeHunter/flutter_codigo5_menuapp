import 'package:flutter/material.dart';
import 'package:flutter_codigo5_menuapp/ui/widgets/text_widget.dart';

import '../general/colors.dart';
import 'general_widget.dart';

class TextFieldPasswordWidget extends StatefulWidget {
  TextEditingController textEditingController;

  TextFieldPasswordWidget({required this.textEditingController});

  @override
  State<TextFieldPasswordWidget> createState() =>
      _TextFieldPasswordWidgetState();
}

class _TextFieldPasswordWidgetState extends State<TextFieldPasswordWidget> {

  bool isInvisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextNormal(text: "Contraseña:"),
        divider6,
        Container(
          margin: const EdgeInsets.only(bottom: 22.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12.0,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: TextFormField(
            obscureText: isInvisible,
            controller: widget.textEditingController,
            maxLines: 1,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(
              fontSize: 14.0,
            ),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              hintText: "Contraseña",
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: kBrandPrimaryColor.withOpacity(0.5),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                onPressed: () {
                  isInvisible = !isInvisible;
                  setState(() {});
                },
                icon: Icon(
                  isInvisible ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                  color: kBrandPrimaryColor.withOpacity(0.67),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return "Campo requerido";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
