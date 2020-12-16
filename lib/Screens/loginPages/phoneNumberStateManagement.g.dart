// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phoneNumberStateManagement.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$phoneNumberStateClass on phoneNumberState, Store {
  final _$phoneNumberAtom = Atom(name: 'phoneNumberState.phoneNumber');

  @override
  String get phoneNumber {
    _$phoneNumberAtom.reportRead();
    return super.phoneNumber;
  }

  @override
  set phoneNumber(String value) {
    _$phoneNumberAtom.reportWrite(value, super.phoneNumber, () {
      super.phoneNumber = value;
    });
  }

  final _$countryCodeAtom = Atom(name: 'phoneNumberState.countryCode');

  @override
  String get countryCode {
    _$countryCodeAtom.reportRead();
    return super.countryCode;
  }

  @override
  set countryCode(String value) {
    _$countryCodeAtom.reportWrite(value, super.countryCode, () {
      super.countryCode = value;
    });
  }

  final _$verificationIDAtom = Atom(name: 'phoneNumberState.verificationID');

  @override
  String get verificationID {
    _$verificationIDAtom.reportRead();
    return super.verificationID;
  }

  @override
  set verificationID(String value) {
    _$verificationIDAtom.reportWrite(value, super.verificationID, () {
      super.verificationID = value;
    });
  }

  final _$resendingTokenAtom = Atom(name: 'phoneNumberState.resendingToken');

  @override
  int get resendingToken {
    _$resendingTokenAtom.reportRead();
    return super.resendingToken;
  }

  @override
  set resendingToken(int value) {
    _$resendingTokenAtom.reportWrite(value, super.resendingToken, () {
      super.resendingToken = value;
    });
  }

  final _$errorWhileEnteringPhoneNumberAtom =
      Atom(name: 'phoneNumberState.errorWhileEnteringPhoneNumber');

  @override
  String get errorWhileEnteringPhoneNumber {
    _$errorWhileEnteringPhoneNumberAtom.reportRead();
    return super.errorWhileEnteringPhoneNumber;
  }

  @override
  set errorWhileEnteringPhoneNumber(String value) {
    _$errorWhileEnteringPhoneNumberAtom
        .reportWrite(value, super.errorWhileEnteringPhoneNumber, () {
      super.errorWhileEnteringPhoneNumber = value;
    });
  }

  final _$errorWhileEnteringOTPAtom =
      Atom(name: 'phoneNumberState.errorWhileEnteringOTP');

  @override
  String get errorWhileEnteringOTP {
    _$errorWhileEnteringOTPAtom.reportRead();
    return super.errorWhileEnteringOTP;
  }

  @override
  set errorWhileEnteringOTP(String value) {
    _$errorWhileEnteringOTPAtom.reportWrite(value, super.errorWhileEnteringOTP,
        () {
      super.errorWhileEnteringOTP = value;
    });
  }

  final _$SpinnerAtom = Atom(name: 'phoneNumberState.Spinner');

  @override
  bool get Spinner {
    _$SpinnerAtom.reportRead();
    return super.Spinner;
  }

  @override
  set Spinner(bool value) {
    _$SpinnerAtom.reportWrite(value, super.Spinner, () {
      super.Spinner = value;
    });
  }

  final _$resendButtonAtom = Atom(name: 'phoneNumberState.resendButton');

  @override
  bool get resendButton {
    _$resendButtonAtom.reportRead();
    return super.resendButton;
  }

  @override
  set resendButton(bool value) {
    _$resendButtonAtom.reportWrite(value, super.resendButton, () {
      super.resendButton = value;
    });
  }

  final _$phoneNumberStateActionController =
      ActionController(name: 'phoneNumberState');

  @override
  void hideResetButton() {
    final _$actionInfo = _$phoneNumberStateActionController.startAction(
        name: 'phoneNumberState.hideResetButton');
    try {
      return super.hideResetButton();
    } finally {
      _$phoneNumberStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSpinner() {
    final _$actionInfo = _$phoneNumberStateActionController.startAction(
        name: 'phoneNumberState.setSpinner');
    try {
      return super.setSpinner();
    } finally {
      _$phoneNumberStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setResendingToken(int token) {
    final _$actionInfo = _$phoneNumberStateActionController.startAction(
        name: 'phoneNumberState.setResendingToken');
    try {
      return super.setResendingToken(token);
    } finally {
      _$phoneNumberStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhoneNumber(String phoneNumber) {
    final _$actionInfo = _$phoneNumberStateActionController.startAction(
        name: 'phoneNumberState.setPhoneNumber');
    try {
      return super.setPhoneNumber(phoneNumber);
    } finally {
      _$phoneNumberStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCountryCode(String countryCode) {
    final _$actionInfo = _$phoneNumberStateActionController.startAction(
        name: 'phoneNumberState.setCountryCode');
    try {
      return super.setCountryCode(countryCode);
    } finally {
      _$phoneNumberStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setverificationID(String verificationID) {
    final _$actionInfo = _$phoneNumberStateActionController.startAction(
        name: 'phoneNumberState.setverificationID');
    try {
      return super.setverificationID(verificationID);
    } finally {
      _$phoneNumberStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getErrorWhileEnteringPhoneNumber(String errorWhileEnteringPhoneNumber) {
    final _$actionInfo = _$phoneNumberStateActionController.startAction(
        name: 'phoneNumberState.getErrorWhileEnteringPhoneNumber');
    try {
      return super
          .getErrorWhileEnteringPhoneNumber(errorWhileEnteringPhoneNumber);
    } finally {
      _$phoneNumberStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getErrorWhileEnteringOTP(String errorWhileEnteringOTP) {
    final _$actionInfo = _$phoneNumberStateActionController.startAction(
        name: 'phoneNumberState.getErrorWhileEnteringOTP');
    try {
      return super.getErrorWhileEnteringOTP(errorWhileEnteringOTP);
    } finally {
      _$phoneNumberStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
phoneNumber: ${phoneNumber},
countryCode: ${countryCode},
verificationID: ${verificationID},
resendingToken: ${resendingToken},
errorWhileEnteringPhoneNumber: ${errorWhileEnteringPhoneNumber},
errorWhileEnteringOTP: ${errorWhileEnteringOTP},
Spinner: ${Spinner},
resendButton: ${resendButton}
    ''';
  }
}
