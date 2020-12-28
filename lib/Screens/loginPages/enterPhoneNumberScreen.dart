import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:flutter/material.dart';
import 'phoneNumberStateManagement.dart';
import 'loginFunctionalities.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../widgets/custom-painter.dart';
import '../../widgets/bottom-painter.dart';

import 'phone_input/home.dart';

class enterPhoneNumber extends StatefulWidget {
  @override
  _enterPhoneNumberState createState() => _enterPhoneNumberState();
}

class _enterPhoneNumberState extends State<enterPhoneNumber> {
  TextEditingController phoneNumber;
  phoneNumberStateClass PNS;

  @override
  void initState() {
    PNS = new phoneNumberStateClass();
    phoneNumber = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: buildAppBar(context),
      body: Observer(
        builder: (context) {
          return PNS.verificationID == ''
              ? ModalProgressHUD(
                  inAsyncCall: PNS.Spinner, child: InputPhoneAndName(PNS: PNS))
              : Stack(
                children: [
                  BottomPainter(
            top:
                MediaQuery.of(context).size.height - (kToolbarHeight + 24 + 80),
            painter: LightVioletCustomPaint(),
          ),
          BottomPainter(
            top:
                MediaQuery.of(context).size.height - (kToolbarHeight + 24 + 80),
            painter: VioletCustomPaint(),
          ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .05,),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              "OTP",
                              style: TextStyle(
                                fontSize: 28,
                                color: Color(0xffF49154),
                              ),
                            ),
                          ),
                          Text(
                            "We’ve sent you an SMS with a verification code.\nPlease Insert the code below.",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff959595),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                'Enter your OTP number',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff5E5E5E),
                                ),
                              ),
                            ),
                          ),
                          Form(
                            key: formKey,
                            // ignore: missing_required_param
                            child: PinCodeTextField(
                              appContext: context,
                              backgroundColor: Colors.transparent,
                              pinTheme: PinTheme(
                                selectedColor: Colors.white,
                                selectedFillColor: Colors.white,
                                activeColor: Colors.white,
                                inactiveFillColor: Colors.white,
                                inactiveColor: Colors.white,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 60,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                              ),
                              pastedTextStyle: TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 6,
                              obscureText: false,
                              obscuringCharacter: '*',
                              animationType: AnimationType.fade,
                              cursorColor: Colors.black,
                              animationDuration: Duration(milliseconds: 300),
                              textStyle: TextStyle(fontSize: 20, height: 1.6),
                              enableActiveFill: true,
                              keyboardType: TextInputType.number,
                              boxShadows: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (pin) {
                                LogInWithOTP(context, pin, PNS);
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                return true;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Observer(
                                builder: (context) {
                                  return Center(
                                    child: Text(
                                      PNS.errorWhileEnteringOTP,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 10),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // if (PNS.resendButton)
                          //   InkWell(
                          //     onTap: () {
                          //       PNS.hideResetButton();
                          //       LogInWIthPhone(PNS, context);
                          //     },
                          //     child: Padding(
                          //       padding: EdgeInsets.only(
                          //           left: 30.0, right: 30, bottom: 30, top: 20),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //             color: Color(0xff1d1c79),
                          //             borderRadius: BorderRadius.circular(25)),
                          //         width: 220,
                          //         height: 55,
                          //         child: Center(
                          //           child: Text(
                          //             'Resend code',
                          //             style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),

                          if (PNS.resendButton)
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Did not receive the code? ",
                                      style: TextStyle(
                                        color: Color(0xff959595),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: InkWell(
                                        onTap: () {
                                          PNS.hideResetButton();
                                          LogInWIthPhone(PNS, context);
                                        },
                                        child: Text(
                                          "Resend",
                                          style: TextStyle(
                                            color: Color(0xff6E8EFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Spacer(),
                        ],
                      ),
                    ),
                ],
              );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff959595),
            size: 16,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
}
