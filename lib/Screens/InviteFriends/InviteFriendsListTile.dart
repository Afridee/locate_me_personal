import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:locate_me/Screens/homeScreen/mapStateManagment.dart';
import 'package:locate_me/widgets/dialogue.dart';

class InviteFriendsListTile extends StatelessWidget {

  final Contact contact;

  const InviteFriendsListTile({
    Key key,
    @required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    MapStatecontroller mapStatecontroller = Get.put(MapStatecontroller(context));

    return ListTile(
      leading: CircleAvatar(
        radius: 60,
        backgroundColor: Color(0xfff49154),
        child: Text(
          contact.displayName.toUpperCase().substring(0, 1),
          style: TextStyle(color: Colors.white, fontSize: 38),
        ),
      ),
      title: Text(contact.displayName),
      subtitle: Text(contact.phones.first.value),
      trailing: InkWell(
        onTap: (){
          mapStatecontroller.sendSMS(number: contact.phones.first.value,message: "Hey, I'm using Locate Me, check it out\n\nhttps://play.google.com/store/apps/details?id=com.oreostudio.locate_me" );
          appShowDialog(context, "Invitation sent", "Invitation message sent to ${contact.displayName}", Color(0xfff49154));
        },
        child: Container(
          width: 60,
          height: 25,
          child: Center(
            child: Text(
              "Invite",
               style: TextStyle(
                 color: Colors.white
               ),
            ),
          ),
          decoration: BoxDecoration(
             color: Color(0xfff49154),
             borderRadius: BorderRadius.circular(15)
          ),
        ),
      ),
    );
  }
}