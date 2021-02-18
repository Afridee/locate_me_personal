import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/PickContacts/contacts.dart';
import 'Screens/TermsAndConditions.dart';
import 'Screens/homeScreen/HomeScreen.dart';

class EntryPhase2 extends StatefulWidget {
  @override
  _EntryPhase2State createState() => _EntryPhase2State();
}

class _EntryPhase2State extends State<EntryPhase2> {

  SharedPreferences prefs;
  bool termsAccepted = false;


  initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('termsAccepted')==null) {
        prefs.setBool('termsAccepted', false);
        setState(() {
          termsAccepted =  prefs.getBool('termsAccepted');
        });
    }else{
      setState(() {
        termsAccepted =  prefs.getBool('termsAccepted');
      });
    }
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hive.box<Map>("selected_contact_box").isNotEmpty? Home() : ( termsAccepted ? Contacts(willpop: false) : TramsAndCondition());
  }
}
