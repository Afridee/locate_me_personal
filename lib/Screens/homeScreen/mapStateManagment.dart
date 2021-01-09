import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:location/location.dart';
import 'package:shake/shake.dart';
import 'package:sms/sms.dart';
import 'package:provider/provider.dart';
import '../../Screens/loginPages/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class MapStatecontroller extends GetxController {

  MapStatecontroller(){
    enable_shake();
  }

  GoogleMapController _controller;
  Location _locationTracker = Location();
  Marker marker;
  StreamSubscription _locationSubscription;
  bool shareLiveLocation = false;
  ShakeDetector detector;
  bool pauseSMS = false;
  bool updateLocation = true;

  void pauseLocationUpdate() {
    Timer(Duration(seconds: 20),(){
      updateLocation = !updateLocation ;
      update();
    });
    updateLocation  = !updateLocation;
    update();
  }

  Future<void> getFruit() async {
//get helper example:
//    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getHelpers');
//    final results = await callable({'latitude': 23.8680437,'longitude':90.3944072});
//    List fruit = results.data;
//    print(fruit);

//send help request example:
//    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendRequestToHelpers');
//    final results = await callable('f5bTwDrbTAOL0Qr6q7UTb1:APA91bFDcxHzAtyEZZm2Bf7Shm690HSEPNOoCwpS4MSCEiHq4rqzG_WAYeNwwaFIwzpA_3JCWix1e3i2fcoEbS1WuEZ6tuCJDSjNTEhkDQ3yMfKXM8pJRgtEaTtBnW7zt-ypL_60sJb4');
//    print('push status: ' + results.toString());
  }

  updatingLocationOnFirebase(LocationData newLocation) async{

    //getting the user's UID:
    final auth = fba.FirebaseAuth.instance;
    final fba.User user = auth.currentUser;
    String _userID = user.uid;

    final geo = Geoflutterfire();
    GeoFirePoint myLocation = geo.point(latitude: newLocation.latitude, longitude: newLocation.longitude);

    final CollectionReference users = FirebaseFirestore.instance.collection('Users');
    await users.doc(_userID).update({
      'g' : myLocation.data
    });
  }

  send_SMS_Location_To_Trusted_Contacts(BuildContext context, LocationData location){
    Box<Map> selected_contact_box = Hive.box<Map>("selected_contact_box");
    final auth  = Provider.of<FirebaseAuthService>(context, listen: false);

    selected_contact_box.values.toList().forEach((element) {
      print('sms sent to ${element['phones'].first['value']} : ' +
      "${auth.userInfo['full_name']} may be in danger, he's current location is:\nhttps://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}"
      );
    });
  }

  void pauseSMS_sender() {
    Timer(Duration(seconds: 20),(){
      pauseSMS = !pauseSMS ;
      update();
    });
    pauseSMS  = !pauseSMS;
    update();
  }

  void sendSMS({String number, String message}){
    SmsSender sender = new SmsSender();
    sender.sendSms(new SmsMessage(number, message));
  }

  enable_shake(){
    detector = ShakeDetector.waitForStart(
        onPhoneShake: () {
          toggleButton_for_shareLive();
        }
    );
    detector.startListening();
    update();
  }

  void toggleButton_for_shareLive() {
    shareLiveLocation = !shareLiveLocation;
    update();
  }

  void setController(GoogleMapController controller){
    _controller = controller;
    update();
  }

  Future<Uint8List> getMarker(BuildContext context, String icon) async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load(icon);
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);

    marker = Marker(
        markerId: MarkerId("you"),
        position: latlng,
        //rotation: newLocalData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 1),
        icon: BitmapDescriptor.fromBytes(imageData));
    update();
  }

  Future<void> getCurrentLocation(BuildContext context) async {

    try {
      Uint8List imageData = await getMarker(context, "assets/images/you_are_here_2.png");

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData)
      {
          updateMarkerAndCircle(newLocalData, imageData);

          if(shareLiveLocation && !pauseSMS){
            send_SMS_Location_To_Trusted_Contacts(context, newLocalData);
            pauseSMS_sender();
          }

          if(updateLocation){
            updatingLocationOnFirebase(newLocalData);
            pauseLocationUpdate();
          }

          if (_controller != null) {
            _controller.animateCamera(
              CameraUpdate.newCameraPosition(
                new CameraPosition(
                  zoom: 18,
                  //bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                ),
              ),
            );
          }
        },
      );
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }

    update();
  }

}