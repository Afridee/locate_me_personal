import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';




void disclosure(BuildContext context, String title, String content, Color
color) {
  // flutter defined function
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(
          title,
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontFamily: 'Varela'),
        ),
        content: new Text(
          content,
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontFamily: 'Varela'),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "Accept",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontFamily: 'Varela',
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async{
              Navigator.of(context).pop();
              final status = await Permission.location.request();
            },
          ),
        ],
        backgroundColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
      );
    },
  );
}