import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Screens/EditEmergengyContacts/edit_emergency_contacts.dart';
import '../Screens/helpRequests/help_requests.dart';
import '../Screens/loginPages/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({
    Key key,
  }) : super(key: key);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    final auth  = Provider.of<FirebaseAuthService>(context, listen: false);
    return Drawer(
      child: Container(
        color: Color(0xff410DA2),
        child: ListView(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(100))
                ),
                height: 100,
                width: 100,
                child: ClipOval(
                  child: Image.network(
                    auth.userInfo['profile_image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                  color: Colors.white
              ),
            ),
            drawerListTile(title: 'Help requests',action: (){
              Navigator.of(context).pop();
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => new HelpRequests(),
              );
              Navigator.of(context).push(route);
            }),
            drawerListTile(title: 'Change Emergency\nContacts',action: (){
              Navigator.of(context).pop();
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => new EditEmergencyContacts(),
              );
              Navigator.of(context).push(route);
            }),
          ],
        ),
      ),
    );
  }
}

class drawerListTile extends StatelessWidget {

  final String title;
  final Function action;

  const drawerListTile({
    Key key,@required this.title,@required this.action
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20
            ),
          ),
        ),
      ),
    );
  }
}