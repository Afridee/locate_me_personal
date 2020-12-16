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

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Color(0xffFFFFFF),
          body: Observer(builder: (context) {
            return ModalProgressHUD(
              inAsyncCall: LS.Spinner,
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/Background.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 50),
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: FadeAnimation(
                            1.5,
                            Image(
                              image: AssetImage('assets/images/locate_me_icon.png'),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Locate Me',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                  'Emergency Location Sharing App'
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 30.0, right: 30, bottom: 30, top: 20),
                        child: InkWell(
                          onTap: (){
                            var route = new MaterialPageRoute(
                              builder: (BuildContext context) =>
                              new enterPhoneNumber(),
                            );
                            Navigator.of(context).push(route);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff1d1c79),
                              borderRadius: BorderRadius.circular(25)
                            ),
                            width: 220,
                            height: 55,
                            child: Center(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }
}
