import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Screens/PickContacts/contacts.dart';

import 'emergency_contact_list_tile.dart';

class EditEmergencyContacts extends StatefulWidget {
  EditEmergencyContacts({Key key}) : super(key: key);

  @override
  _EditEmergencyContactsState createState() => _EditEmergencyContactsState();
}

class _EditEmergencyContactsState extends State<EditEmergencyContacts> {

  Box<Map> selected_contact_box;

  @override
  void initState() {
    selected_contact_box = Hive.box<Map>("selected_contact_box");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
         children: [
           Expanded(
             flex: 7,
             child: Container(
               child: ValueListenableBuilder(
                 valueListenable: selected_contact_box.listenable(),
                 builder: (context, Box<Map> selectedcontactbox, _) {
                   return ListView.separated(
                       itemBuilder: (context, index) {
                         return EmergencyContactListTile(contact: selectedcontactbox.values.toList()[index]);
                       },
                       separatorBuilder: (_, index) => Divider(),
                       itemCount: selectedcontactbox.keys.toList().length);
                 },
               ),
             ),
           ),
           Expanded(
             child: Container(
               child: Center(
                 child: InkWell(
                   onTap: (){
                     Navigator.of(context).pop();
                     var route = new MaterialPageRoute(
                       builder: (BuildContext context) => new Contacts(willpop: true),
                     );
                     Navigator.of(context).push(route);
                   },
                   child: Container(
                     child: Center(
                         child: Text(
                           'Change',
                           style: TextStyle(fontSize: 17, color: Colors.white),
                         )),
                     height: 50,
                     width: 300,
                     decoration: BoxDecoration(
                       boxShadow: [
                         BoxShadow(
                           color: Color(0xff410DA2).withOpacity(0.5),
                           spreadRadius: 0.1,
                           blurRadius: 3,
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
           ),
           Expanded(
             child: Container(
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
                           spreadRadius: 0.1,
                           blurRadius: 3,
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