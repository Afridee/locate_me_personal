import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:locate_me/Screens/InviteFriends/InviteFriendsListTile.dart';
import 'package:locate_me/Screens/PickContacts/contacts_state_management.dart';

class InviteFriends extends StatefulWidget {
  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ContactStatecontroller _ContactStatecontroller = Get.put(ContactStatecontroller());
    return Scaffold(
      appBar: buildAppBar(context),
        body: Container(
     child: Center(
        child: GetBuilder<ContactStatecontroller>(
          builder: (csc){
            return ListView.builder(
              itemCount: csc.contact_list.length,
              itemBuilder: (context, index){
                return InviteFriendsListTile(contact: csc.contact_list[index]['contact_info']);
              },
            );
          },
        ),
     ),
    ));
  }
}


AppBar buildAppBar(BuildContext context) {
  return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Color(0xffF26F50)),
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Image(
                image: AssetImage("assets/images/locate_me_icon.png"),
                width: 15,
              ),
            ),
            TextSpan(
              text: "  Locate Me",
              style: TextStyle(
                color: Color(0xff1C2D69),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ));
}
