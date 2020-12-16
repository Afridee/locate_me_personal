import 'package:flutter/material.dart';
import '../../phoneNumberStateManagement.dart';
import 'background.dart';
import 'home-content.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    Key key,
    @required this.size, this.PNS,
  }) : super(key: key);

  final Size size;
  final phoneNumberStateClass PNS;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HomeBackground(size: size),
        HomeContent(size: size,PNS: PNS,),
      ],
    );
  }
}

