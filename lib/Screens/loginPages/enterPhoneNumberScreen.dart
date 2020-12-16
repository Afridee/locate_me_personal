import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../Constants.dart';
import 'package:flutter/material.dart';
import 'phoneNumberStateManagement.dart';
import 'loginFunctionalities.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
      body: Observer(
        builder: (context) {
          return PNS.verificationID == ''
              ? ModalProgressHUD(inAsyncCall: PNS.Spinner,child: InputPhoneAndName(PNS: PNS))
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Background.png"),
                  fit: BoxFit.fill,
                ),
              ),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Enter your OTP number',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: formKey,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 30),
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
                            )),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Observer(
                            builder: (context){
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
                      if(PNS.resendButton) InkWell(
                        onTap: (){
                          PNS.hideResetButton();
                          LogInWIthPhone(PNS, context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 30.0, right: 30, bottom: 30, top: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff1d1c79),
                                borderRadius: BorderRadius.circular(25)
                            ),
                            width: 220,
                            height: 55,
                            child: Center(
                              child: Text(
                                'Resend code',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ));
        },
      ),
    );
  }
}
