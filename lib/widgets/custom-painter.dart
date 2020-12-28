import 'package:flutter/material.dart';

class VioletCustomPaint extends CustomPainter{
  
  @override
  void paint(Canvas canvas, Size size) {
    
    

  Paint paint_0 = new Paint()
      ..color = Color(0xff410DA2)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
     
         
    Path path_0 = Path();
    path_0.moveTo(0,size.height*0.40);
    path_0.lineTo(0,size.height);
    path_0.lineTo(size.width,size.height);
    path_0.lineTo(size.width,size.height*0.30);
    path_0.quadraticBezierTo(size.width*0.95,size.height*0.38,size.width*0.89,size.height*0.46);
    path_0.cubicTo(size.width*0.74,size.height*0.64,size.width*0.66,size.height*0.58,size.width*0.60,size.height*0.48);
    path_0.cubicTo(size.width*0.51,size.height*0.34,size.width*0.43,size.height*0.17,size.width*0.33,size.height*0.28);
    path_0.cubicTo(size.width*0.26,size.height*0.35,size.width*0.26,size.height*0.36,size.width*0.17,size.height*0.44);
    path_0.quadraticBezierTo(size.width*0.07,size.height*0.50,0,size.height*0.40);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}






class LightVioletCustomPaint extends CustomPainter{
  
  @override
  void paint(Canvas canvas, Size size) {
    
    

  Paint paint_0 = new Paint()
      ..color = Color(0xff9785A7)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
     
         
    Path path_0 = Path();
    path_0.moveTo(0,size.height*0.29);
    path_0.lineTo(0,size.height);
    path_0.lineTo(size.width,size.height);
    path_0.lineTo(size.width,size.height*0.25);
    path_0.quadraticBezierTo(size.width*0.98,size.height*0.29,size.width*0.81,size.height*0.45);
    path_0.cubicTo(size.width*0.72,size.height*0.50,size.width*0.67,size.height*0.48,size.width*0.59,size.height*0.39);
    path_0.cubicTo(size.width*0.49,size.height*0.23,size.width*0.41,size.height*0.21,size.width*0.33,size.height*0.28);
    path_0.cubicTo(size.width*0.25,size.height*0.35,size.width*0.25,size.height*0.35,size.width*0.17,size.height*0.40);
    path_0.quadraticBezierTo(size.width*0.08,size.height*0.45,0,size.height*0.29);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}
