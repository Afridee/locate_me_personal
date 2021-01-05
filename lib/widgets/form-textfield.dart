import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class formTextfield extends StatelessWidget {

  final label;
  final TextEditingController textController;
  final inputType;
  final hintText;
  final Widget prefixIcon;

  const formTextfield({
    Key key, this.label,@required this.textController,@required this.inputType,@required this.hintText, this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        keyboardType: inputType,
        controller: textController,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText.toString(),
            labelText: label.toString(),
            labelStyle: TextStyle(
              color: Color(0xffF17350),
            )
        ),
      ),
    );
  }
}