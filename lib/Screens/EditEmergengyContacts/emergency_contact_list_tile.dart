import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class EmergencyContactListTile extends StatelessWidget {
  final Map contact;

  const EmergencyContactListTile({
    Key key,
    @required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: CircleAvatar(
        radius: 60,
        backgroundColor: Color(0xfff49154),
        child: Text(
          contact['displayName'].toUpperCase().substring(0, 1),
          style: TextStyle(color: Colors.white, fontSize: 38),
        ),
      ),
      title: Text(contact['displayName']),
      subtitle: Text(contact['phones'][0]['value']),
    );
  }
}