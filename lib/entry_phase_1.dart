import 'Screens/PickContacts/contacts.dart';
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
  @override
  Widget build(BuildContext context) {
    final auth  = Provider.of<FirebaseAuthService>(context, listen: true);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (_, AsyncSnapshot<User> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          final User user = snapshot.data;
          return user == null? login_page() : (auth.userInfoGiven? EntryPhase2() : form());
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