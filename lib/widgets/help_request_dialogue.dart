import 'package:flutter/material.dart';
import 'package:locate_me/models/RequestModel.dart';


//function 5:
void appShowHelpDialog(BuildContext context, RequestModel request) async{

  String locationName = await request.getRequesterLocationName();

  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(
          "${request.requesterName} needs help",
          style: TextStyle(
              fontSize: 20, color: Colors.red, fontFamily: 'Varela'),
        ),
        content: new Text(
          'Location: $locationName',
          style: TextStyle(
              fontSize: 13, color: Colors.grey, fontFamily: 'Varela', fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "Help",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.green,
                  fontFamily: 'Varela',
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              request.AcceptRejectToggle();
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text(
              "Ignore",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.red,
                  fontFamily: 'Varela',
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
      );
    },
  );
}