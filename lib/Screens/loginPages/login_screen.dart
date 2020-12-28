import 'package:flutter/cupertino.dart';
import 'enterPhoneNumberScreen.dart';
import 'package:flutter/services.dart';
import '../../Animation/FadeAnimation.dart';
import '../../widgets/custom-painter.dart';
import '../../widgets/bottom-painter.dart';
import '../../widgets/primary-button.dart';
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
              child: Stack(
                children: [
                  BottomPainter(
                    top: MediaQuery.of(context).size.height - 80,
                    painter: LightVioletCustomPaint(),
                  ),
                  BottomPainter(
                    top: MediaQuery.of(context).size.height - 80,
                    painter: VioletCustomPaint(),
                  ),
                  Container(
                    height: size.height,
                    width: size.width,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Spacer(),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 50),
                          height: 150,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Locate Me',
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xff1C2D69),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5.0,
                          ),
                          child: Text(
                            'Emergency Location Sharing App',
                            style: TextStyle(
                                color: Color(0xff9B9B9B), fontSize: 15),
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * .1, vertical: 35),
                          child: PrimaryButton(
                            size: size.width,
                            text: "GET STARTED",
                            press: () {
                              var route = new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new enterPhoneNumber(),
                              );
                              Navigator.of(context).push(route);
                            },
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(bottom: 80),
                          child: Text(
                            "Oreo Studio | 2020",
                            style: TextStyle(color: Color(0xffB2BCC3)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
