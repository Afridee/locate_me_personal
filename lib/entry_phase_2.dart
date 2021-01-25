import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Screens/PickContacts/contacts.dart';
import 'Screens/homeScreen/HomeScreen.dart';

class EntryPhase2 extends StatefulWidget {
  @override
  _EntryPhase2State createState() => _EntryPhase2State();
}

class _EntryPhase2State extends State<EntryPhase2> {

  @override
  Widget build(BuildContext context) {
    return Hive.box<Map>("selected_contact_box").isNotEmpty? Home() : Contacts(willpop: false);
  }
}
