import 'package:flutter/cupertino.dart';
import 'enterPhoneNumberScreen.dart';
import 'package:flutter/services.dart';
import '../../Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'loginScreenStateManagement.dart';

class login_page extends StatefulWidget {
  @override
  _login_pageState createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  //variables:

  loginScreenStateClass LS;
  //functions:

  //function 1:

  @override
  void initState() {
    LS = new loginScreenStateClass();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Observer(
          builder: (context) {
            return ModalProgressHUD(
              inAsyncCall: LS.Spinner,
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Background.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    height: size.height,
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 50),
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: FadeAnimation(
                              1.5,
                              Image(
                                image: AssetImage(
                                    'assets/images/locate_me_icon.png'),
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Locate Me',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5.0,
                          ),
                          child: Text('Emergency Location Sharing App'),
                        ),
                        Container(
                          width: size.width,
                          height: 60,
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * .1, vertical: 35),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            color: Color(0xff1D1C79),
                            onPressed: () {
                              var route = new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new enterPhoneNumber(),
                              );
                              Navigator.of(context).push(route);
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
