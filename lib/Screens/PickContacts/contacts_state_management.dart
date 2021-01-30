import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:hive/hive.dart';
import 'package:locate_me/widgets/dialogue.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../entry_phase_2.dart';

class ContactStatecontroller extends GetxController {
  List<Map<String,dynamic>> contact_list = new List<Map<String,dynamic>>();
  List<Map<String,dynamic>> selected_contact_list = new List<Map<String,dynamic>>();

  ContactStatecontroller(){
    if(contact_list.isEmpty){
      getContacts();
    }
  }


  void getContacts() async {
    //asking for permission:

    final status = await Permission.contacts.request();
    final status2 = await Permission.phone.request();
    final status3 = await Permission.sms.request();



    //Getting the Contacts:
    contact_list.clear();
    update();

    if (status.isGranted && status2.isGranted && status3.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      for (var contact in contacts) {
        if(contact.phones.isNotEmpty)
        contact_list.add({
          'identifier' : contact.identifier,
          'contact_info' : contact,
          'selected' : false
        });
        update();
      }
    } else if (status.isDenied) {
      print('Permission Denied');
    }
  }

  void changeSelectedStat(String identifier){

    for(int i=0;i<contact_list.length;i++){
       if(contact_list[i]['identifier'] == identifier){
         contact_list[i] = {
           'identifier' : contact_list[i]['identifier'],
           'contact_info' : contact_list[i]['contact_info'],
           'selected' : !contact_list[i]['selected']
         };
         update();
       }
    }

  }

  void onDone(BuildContext context) async{

    selected_contact_list.clear();
    update();

    for(int i=0;i<contact_list.length;i++){
      if(contact_list[i]['selected']){
         selected_contact_list.add(contact_list[i]);
         update();
      }
    }

    if(selected_contact_list.length>=3 && selected_contact_list.length<=5){
      Box<Map> selected_contact_box = Hive.box<Map>("selected_contact_box");

      await selected_contact_box.clear();

      selected_contact_list.forEach((contact) {
        selected_contact_box.put(contact['identifier'], contact['contact_info'].toMap());
      });

      Navigator.of(context).pop();
      var route = new MaterialPageRoute(
        builder: (BuildContext context) => new EntryPhase2(),
      );
      Navigator.of(context).push(route);
    }else{
      appShowDialog(context, 'Uhm!!',
          'please select atleast 3 contacts, but not more than 5', Color(0xffF26F50));
    }
  }

}
