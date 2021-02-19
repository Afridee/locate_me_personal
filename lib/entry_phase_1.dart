import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/TermsAndConditions.dart';
import 'Screens/editProfile/form.dart';
import 'Screens/loginPages/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/loginPages/firebase_auth_service.dart';
import 'entry_phase_2.dart';

class entry_phase_1 extends StatefulWidget {
  @override
  _entry_phase_1State createState() => _entry_phase_1State();
}

class _entry_phase_1State extends State<entry_phase_1> {

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
    final auth  = Provider.of<FirebaseAuthService>(context, listen: true);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (_, AsyncSnapshot<User> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          final User user = snapshot.data;
          return user == null? login_page() : termsAccepted ? (auth.userInfoGiven? EntryPhase2() : form(willPop: false)) : TramsAndCondition();
        }else{
          return Scaffold(
              body: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          );
        }
      },
    );
  }
}