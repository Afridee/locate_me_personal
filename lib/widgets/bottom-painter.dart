import 'package:flutter/material.dart';

class BottomPainter extends StatelessWidget {
  const BottomPainter({
    Key key,
    this.top,
    @required this.painter,
  }) : super(key: key);
  final CustomPainter painter;
  final double top;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        child: Stack(
          overflow: Overflow.visible,
          children: [
            CustomPaint(
              size: Size(
                MediaQuery.of(context).size.width,
                80,
              ),
              painter: painter,
            ),
          ],
        ),
      ),
    );
  }
}
