import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key key,
    @required this.press,
    @required this.text,
    @required this.size,
  }) : super(key: key);
  final String text;
  final Function press;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: 40,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: Color(0xffF17350),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
