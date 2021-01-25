import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Screens/helpRequests/requestListTile.dart';
import '../../Screens/loginPages/firebase_auth_service.dart';
import '../../models/RequestModel.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

class HelpRequests extends StatefulWidget {
  HelpRequests({Key key}) : super(key: key);

  @override
  _HelpRequestsState createState() => _HelpRequestsState();
}

class _HelpRequestsState extends State<HelpRequests> {
  List<RequestModel> requests = new List<RequestModel>();

  @override
  void initState() {
    try {
      FirebaseFirestore.instance
          .collection('HelpRequests')
          .where('helper_id',
              isEqualTo: fba.FirebaseAuth.instance.currentUser.uid)
          .where('requester_called_off', isEqualTo: false)
          .snapshots()
          .listen((event) {
           requests.clear();
           event.docs.toList().forEach((element) {
            if(DateTime.now().isBefore(DateTime.fromMicrosecondsSinceEpoch(element.data()['expire_date'].microsecondsSinceEpoch))){
              setState(() {
                requests.add(RequestModel.fromJson(element.data()));
              });
            }
          });
        },
      );
    } catch (err) {
      print('Error in HelpRequests init: ' + err.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: true);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index){
                    return requestListTile(
                      request: requests[index],
                    );
                  },
                )
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Center(
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    child: Center(
                        child: Text(
                      'Done',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    )),
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff410DA2).withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Color(0xff410DA2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

