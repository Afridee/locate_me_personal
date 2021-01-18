import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:location/location.dart';
import 'package:sms/sms.dart';
import 'package:shake/shake.dart';
import 'package:provider/provider.dart';
import '../../Screens/loginPages/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class MapStatecontroller extends GetxController {

  GoogleMapController _controller;
  Location _locationTracker = Location();
  Marker marker;
  List<Marker> otherMarkers = new List<Marker>();
  StreamSubscription _locationSubscription;
  bool shareLiveLocation = false;
  ShakeDetector detector;
  bool pauseSMS = false;
  bool updateLocation = true;
  bool askForHelpButtonClickable = true;
  List<Map<String, dynamic>> others = new List<Map<String, dynamic>>();
  GeoPoint g;
  StreamSubscription help_request_collection_listener;
  StreamSubscription user_collection_listener;

  //Constructor:
  MapStatecontroller(BuildContext context){
    updateFcmToken();
    enable_shake();
    enable_help_request_collection_listener(context);
  }

  enable_help_request_collection_listener(BuildContext context){
     try{
       help_request_collection_listener = FirebaseFirestore.instance.collection('HelpRequests')
           .where('helper_and_requester', arrayContains: fba.FirebaseAuth.instance.currentUser.uid)
           .where('req_status',isEqualTo: 'accepted')
           .where('requester_called_off',isEqualTo: false)
           .snapshots().listen((event) {

         others.clear();
         update();

         event.docs.toList().forEach((element) {
           if(DateTime.now().isBefore(DateTime.fromMicrosecondsSinceEpoch(element.data()['expire_date'].microsecondsSinceEpoch))){
             if(element.data()['helper_id'] == fba.FirebaseAuth.instance.currentUser.uid){
               others.add({
                 'id' : element.data()['requester_id'],
                 'marker' : 'requester'
               });
               update();
             }else{
               others.add({
                 'id' : element.data()['helper_id'],
                 'marker' : 'helper'
               });
               update();
             }
           }
         });

         Timer(Duration(seconds: 5),(){});  //pause for like 5 seconds...

         if(user_collection_listener!=null){
           user_collection_listener.cancel();
           enable_user_collection_listener(context);
         }else{
           enable_user_collection_listener(context);
         }

       });
     }catch(error){
       print('Error while enabling help request collection listener: ' + error.toString());
     }
  }

  enable_user_collection_listener(BuildContext context){
      try{
        user_collection_listener = FirebaseFirestore.instance.collection('Users')
            .where('user_id', arrayContainsAny: others_just_uid_list(others))
            .snapshots()
            .listen((event) {
          otherMarkers.clear();
          update();

          event.docs.toList().forEach((element) async{

            Uint8List imageData = await getMarker(context, "assets/images/you_are_here.png");

            otherMarkers.add(
                Marker(
                    markerId: MarkerId(element.data()['user_id'][0]),
                    position: LatLng(element.data()['g']['geopoint'].latitude,element.data()['g']['geopoint'].longitude),
                    draggable: false,
                    zIndex: 2,
                    flat: true,
                    anchor: Offset(0.5, 1),
                    icon: BitmapDescriptor.fromBytes(imageData))
            );
          });

          update();
        });
      }catch(error){
        print('Error while enabling user collection listener: ' + error.toString());
      }
  }

  List<String> others_just_uid_list(List<Map<String, dynamic>> others){
    List<String> uid_list = new List<String>();

    others.forEach((element) {
      uid_list.add(element['id']);
    });

    return uid_list;
  }

  void updateFcmToken() async{
    try{
      //getting the user's UID:
      final auth = fba.FirebaseAuth.instance;
      final fba.User user = auth.currentUser;
      String _userID = user.uid;

      final FirebaseMessaging  _firebaseMessaging = FirebaseMessaging();
      String fcmToken = await _firebaseMessaging.getToken();
      final CollectionReference users = FirebaseFirestore.instance.collection('Users');
      await users.doc(_userID).update(
        {
          'fcm' : fcmToken
        },
      );
    }catch(error){
      print('error while updating fcm: ' + error);
    }
  }

  void pauseLocationUpdate() {
    Timer(Duration(seconds: 20),(){
      updateLocation = !updateLocation ;
      update();
    });
    updateLocation  = !updateLocation;
    update();
  }

  void pauseAskForHelp() {
    Timer(Duration(seconds: 60),(){
      askForHelpButtonClickable = !askForHelpButtonClickable ;
      update();
    });
    askForHelpButtonClickable  = !askForHelpButtonClickable;
    update();
  }

  Future<void> askForHelp() async {

    //to stop the user from constantly clicking
    pauseAskForHelp();

    //getting the user's UID:
    final auth = fba.FirebaseAuth.instance;
    final fba.User user = auth.currentUser;
    String _userID = user.uid;
    
    //getting helper's list:
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getHelpers');
    final results = await callable({'latitude': marker.position.latitude,'longitude':marker.position.longitude});
    List helpers = results.data;
    print('helpers: ' + helpers.toString());

    //send help request notification example:
    helpers.forEach((element) async{


      if(element['id']!=_userID) { //User himself gets cut off from the list
        FirebaseFirestore.instance.doc('Users/${element['id']}').get().then((value) => {
           sendNotification(value.data()['fcm'])
         });
      }

      //New Document in HelpRequest Collection will be created:
      final CollectionReference helpRequests = FirebaseFirestore.instance.collection('HelpRequests');

      bool helper_occupied = false;

      try{
        await helpRequests.where('helper_and_requester', arrayContains: element['id']).get().then((snaps){
          snaps.docs.toList().forEach((element) {
            if(DateTime.now().isBefore(DateTime.fromMicrosecondsSinceEpoch(element.data()['expire_date'].microsecondsSinceEpoch)) &&
                element.data()['req_status'] == 'accepted' &&
               !element.data()['requester_called_off']
            ){
              helper_occupied = true;
            }
          });
        });
      }catch(error){
        print('error while checking if helper is occupied: ' + error.toString());
      }

      if (!helper_occupied && _userID != element['id']) {
        helpRequests.add({
          'requester_id' : _userID,
          'helper_id' : element['id'],
          'req_status' : 'accepted',
          'requester_called_off' : false,
          'expire_date' : DateTime.now().add(Duration(days: 1)),
          'helper_and_requester': [_userID, element['id']]
        });
      }
     });
  }
  
  sendNotification(String fcmToken) async{
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendRequestToHelpers');
    final results = await callable(fcmToken);
    print('push status: ' + results.toString());
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
//      print('sms sent to ${element['phones'].first['value']} : ' +
//      "${auth.userInfo['full_name']} may be in danger, he's current location is:\nhttps://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}"
//      );
    sendSMS(number: '${element['phones'].first['value']}',
            message: "${auth.userInfo['full_name']} may be in danger, he's current location is:\nhttps://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}");
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