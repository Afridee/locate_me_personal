import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locate_me/Screens/AboutUs.dart';
import 'package:locate_me/Screens/PrivacyPolicy.dart';
import 'package:locate_me/Screens/UserGuidelines.dart';
import '../Screens/EditEmergengyContacts/edit_emergency_contacts.dart';
import '../Screens/helpRequests/help_requests.dart';
import '../Screens/loginPages/firebase_auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({
    Key key,
  }) : super(key: key);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  SharedPreferences prefs;
  bool enable_shake_detection = true;

  assignPrefs() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('enable_shake_detection') == null) {
      await prefs.setBool('enable_shake_detection', true);
      enable_shake_detection = prefs.getBool('enable_shake_detection');
    } else {
      enable_shake_detection = prefs.getBool('enable_shake_detection');
    }

    setState(() {});
  }

  @override
  void initState() {
    assignPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100))),
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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${auth.userInfo['full_name']}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffF26F50)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Divider(color: Colors.grey),
            ),
            drawerListTile(
                iconBGcolor: Color(0xff49bafb),
                icon: Icon(
                  Icons.person_add_rounded,
                  color: Colors.white,
                ),
                title: 'Change Emergency\nContacts',
                action: () {
                  Navigator.of(context).pop();
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new EditEmergencyContacts(),
                  );
                  Navigator.of(context).push(route);
                }),
            drawerListTile(
                iconBGcolor: Color(0xff8773ef),
                icon: Icon(
                  Icons.description,
                  color: Colors.white,
                ),
                title: 'About Us',
                action: () {
                  Navigator.of(context).pop();
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new AboutUs(),
                  );
                  Navigator.of(context).push(route);
                }),
            drawerListTile(
                iconBGcolor: Color(0xffd06ffb),
                icon: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.white,
                ),
                title: 'User Guidelines',
                action: () {
                  Navigator.of(context).pop();
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new UserGuideline(),
                  );
                  Navigator.of(context).push(route);
                }),
            drawerListTile(
                iconBGcolor: Color(0xff84dff7),
                icon: Icon(
                  Icons.privacy_tip,
                  color: Colors.white,
                ),
                title: 'Privacy Policy',
                action: () {
                  Navigator.of(context).pop();
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new PrivacyPolicy(),
                  );
                  Navigator.of(context).push(route);
                }),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Enable Shake\nDetection',
                        style:
                            TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: 40.0,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: enable_shake_detection
                              ? Colors.greenAccent[100]
                              : Colors.redAccent[100]),
                      child: Stack(
                        children: <Widget>[
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                            top: 3.0,
                            left: enable_shake_detection ? 30.0 : 0.0,
                            right: enable_shake_detection ? 0.0 : 30.0,
                            child: InkWell(
                              onTap: () async {
                                await prefs.setBool('enable_shake_detection',
                                    !prefs.getBool('enable_shake_detection'));
                                enable_shake_detection =
                                    prefs.getBool('enable_shake_detection');
                                setState(() {});
                              },
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return RotationTransition(
                                    child: child,
                                    turns: animation,
                                  );
                                },
                                child: enable_shake_detection
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 35.0,
                                        key: UniqueKey(),
                                      )
                                    : Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.red,
                                        size: 35.0,
                                        key: UniqueKey(),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class drawerListTile extends StatelessWidget {
  final String title;
  final Function action;
  final Icon icon;
  final Color iconBGcolor;

  const drawerListTile(
      {Key key,
      @required this.title,
      @required this.action,
      @required this.icon,
      @required this.iconBGcolor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, bottom: 25),
        child: Center(
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: Center(child: icon),
                backgroundColor: iconBGcolor,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
