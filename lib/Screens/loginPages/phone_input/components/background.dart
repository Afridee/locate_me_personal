import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/Background.png"),
            fit: BoxFit.fill),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text(
              "By creating an account you agree to our\nTerms of Services and Privacy Policy", style:TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold,) ,),
        ),
      ),
    );
  }
}
