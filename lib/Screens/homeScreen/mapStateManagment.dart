import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:shake/shake.dart';
import 'package:sms/sms.dart';
import 'package:provider/provider.dart';
import '../../Screens/loginPages/firebase_auth_service.dart';

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
          toggleButton_for_reminder();
        }
    );
    detector.startListening();
    update();
  }

  void toggleButton_for_reminder() {
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