import 'package:flutter/material.dart';
import '../phoneNumberStateManagement.dart';
import './components/body.dart';

class InputPhoneAndName extends StatelessWidget {

  final phoneNumberStateClass PNS;

  const InputPhoneAndName({Key key, this.PNS}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: HomeBody(size: size, PNS: PNS,),
    );
  }
}

