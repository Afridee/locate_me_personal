import 'dart:async';

import 'package:mobx/mobx.dart';

part 'phoneNumberStateManagement.g.dart';

class phoneNumberStateClass = phoneNumberState with _$phoneNumberStateClass;

abstract class phoneNumberState with Store{
 //
  @observable
  String phoneNumber = '';

  @observable
  String countryCode = '+880';

  @observable
  String verificationID = '';

  @observable
  int resendingToken;

  @observable
  String errorWhileEnteringPhoneNumber = '';

  @observable
  String errorWhileEnteringOTP = '';

  @observable
  bool Spinner = false;

  @observable
  bool resendButton = true;

  @action
  void hideResetButton() {
    Timer(Duration(seconds: 20),(){
      resendButton = !resendButton ;
    });
    resendButton  = !resendButton;
  }

  @action
  void setSpinner() {
    Timer(Duration(seconds: 17),(){
      Spinner = !Spinner;
    });
    Spinner = !Spinner;
  }


  @action
  void setResendingToken(int token) {
    this.resendingToken = token;
  }

  @action
  void setPhoneNumber(String phoneNumber) {
      this.phoneNumber = phoneNumber;
  }

  @action
  void setCountryCode(String countryCode ) {
    this.countryCode = countryCode;
  }

  @action
  void setverificationID(String verificationID) {
    this.verificationID = verificationID;
  }

  @action
  void getErrorWhileEnteringPhoneNumber(String errorWhileEnteringPhoneNumber) {
    this.errorWhileEnteringPhoneNumber = errorWhileEnteringPhoneNumber;
  }

  @action
  void getErrorWhileEnteringOTP(String errorWhileEnteringOTP) {
    this.errorWhileEnteringOTP = errorWhileEnteringOTP;
  }
}