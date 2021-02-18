import 'package:flutter/material.dart';
import '../phoneNumberStateManagement.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../loginFunctionalities.dart';
import '../../../widgets/custom-painter.dart';
import '../../../widgets/bottom-painter.dart';
import '../../../widgets/primary-button.dart';

class InputPhoneAndName extends StatelessWidget {
  final phoneNumberStateClass PNS;

  const InputPhoneAndName({Key key, this.PNS}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    TextEditingController phoneNumber = new TextEditingController();
    TextEditingController fullName = new TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
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
            padding: EdgeInsets.symmetric(horizontal: 25),
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: Container(
                height: size.height - 200,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        "Register to Get Started",
                        style: TextStyle(
                          fontSize: 28,
                          color: Color(0xffF49154),
                        ),
                      ),
                    ),
                    Text(
                      "Enter your mobile number to get started",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff959595),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Enter your mobile number",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff5E5E5E),
                        ),
                      ),
                    ),
                    TextField(
                      controller: phoneNumber,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "+88 XXXX XXXX XXX",
                        isDense: true,
                        contentPadding: EdgeInsets.all(15),
                        focusColor: Colors.black,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.black, style: BorderStyle.solid),
                        ),
                      ),
                    ),
                    Observer(
                      builder: (context) {
                        return Container(
                          height: 10,
                          child: Center(
                              child: Text(
                            PNS.errorWhileEnteringPhoneNumber,
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          )),
                        );
                      },
                    ),
                    Spacer(),
                    PrimaryButton(
                      size: size.width,
                      text: "CONTINUE",
                      press: () {
                        PNS.setSpinner();
                        PNS.setPhoneNumber(phoneNumber.text);
                        PNS.setResendingToken(null);
                        LogInWIthPhone(PNS, context);
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  
}
