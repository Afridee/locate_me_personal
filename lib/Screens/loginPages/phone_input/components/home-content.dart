import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../widgets/custom-lebel-textfield.dart';
import '../../loginFunctionalities.dart';
import '../../phoneNumberStateManagement.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    Key key,
    @required this.size, this.PNS,
  }) : super(key: key);

  final Size size;
  final phoneNumberStateClass PNS;

  @override
  Widget build(BuildContext context) {

    TextEditingController phoneNumber = new TextEditingController();
    TextEditingController fullName = new TextEditingController();

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: 25,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25),
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: SingleChildScrollView(
        child: Container(
          height: size.height - 200,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  "Let's Get Started",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomLabelTextField(lebel: "Enter your Mobile Number", hint: "Mobile no. with country code...",controller: phoneNumber,),
              Observer(
                builder: (context){
                  return Container(
                    height: 10,
                    child: Center(
                        child: Text(
                          PNS.errorWhileEnteringPhoneNumber,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 10
                          ),
                        )
                    ),
                  );
                },
              ),
              Container(
                width: size.width,
                height: 60,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Color(0xff1D1C79),
                  onPressed: () {
                    PNS.setSpinner();
                    PNS.setPhoneNumber(phoneNumber.text);
                    PNS.setResendingToken(null);
                    LogInWIthPhone(PNS, context);
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "By clicking continue we will send you a OTP on your phone",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
