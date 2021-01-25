import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'contacts_state_management.dart';

class ContactListTile extends StatelessWidget {
  final Map contact;

  const ContactListTile({
    Key key,
    @required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContactStatecontroller _ContactStatecontroller =
    Get.put(ContactStatecontroller());

    return CheckboxListTile(
      activeColor: Color(0xfff49154),
      onChanged: (value) {
        _ContactStatecontroller.changeSelectedStat(contact['identifier']);
      },
      value: contact['selected'],
      secondary: CircleAvatar(
        radius: 60,
        backgroundColor: Color(0xfff49154),
        child: Text(
          contact['contact_info'].displayName.toUpperCase().substring(0, 1),
          style: TextStyle(color: Colors.white, fontSize: 38),
        ),
      ),
      title: Text(contact['contact_info'].displayName),
      subtitle: Text(contact['contact_info'].phones.first.value),
    );
  }
}