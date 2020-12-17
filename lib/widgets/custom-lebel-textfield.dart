import 'package:flutter/material.dart';

class CustomLabelTextField extends StatelessWidget {
  const CustomLabelTextField({
    Key key,
    @required this.lebel, this.hint, this.controller,
  }) : super(key: key);
  final String lebel;
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            lebel,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            focusColor: Colors.black,
            fillColor: Colors.black,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide:
                  BorderSide(color: Colors.black, style: BorderStyle.solid),
            ),
          ),
        ),
      ],
    );
  }
}
