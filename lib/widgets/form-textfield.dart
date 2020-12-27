import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class formTextfield extends StatelessWidget {

  final label;
  final TextEditingController textController;
  final inputType;
  final hintText;

  const formTextfield({
    Key key,@required this.label,@required this.textController,@required this.inputType,@required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        keyboardType: inputType,
        controller: textController,
        decoration: InputDecoration(
          hintText: hintText.toString(),
            labelText: label.toString()
        ),
      ),
    );
  }
}