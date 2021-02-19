import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'package:provider/provider.dart';
import '../../Screens/loginPages/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapStatecontroller extends GetxController {

  GoogleMapController _controller;
  Set<Circle> circles;
  bool cameraAnimation = true;
  Location _locationTracker = Location();
  LocationData users_current_location;
  List<String> selectedContacts = new List<String>();
  Marker marker;
  List<Marker> otherMarkers = new List<Marker>();
  StreamSubscription _locationSubscription;
  bool shareLiveLocation = false;
  bool updateLocation = true;
  bool askForHelpButtonClickable = true;
  List<Map<String, dynamic>> others = new List<Map<String, dynamic>>();
  GeoPoint g;
  StreamSubscription help_request_collection_listener;
  StreamSubscription user_collection_listener;
  // Object for PolylinePoints
  PolylinePoints polylinePoints;
  // Map storing polylines created by connecting
  // two points
  Map<PolylineId, Polyline> polylines = {};
  SharedPreferences prefs;
  String query = '';


  //Constructor:
  MapStatecontroller(BuildContext context){
    updateFcmToken();
    enable_help_request_collection_listener(context);
    assignPrefs();
    initializeSelectedContacts();
  }

  void locationQuery(String query) async{
    // From a query
    try {
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      _createPolylines(marker, [Marker(
          markerId: MarkerId('destination'),
          position: LatLng(addresses.first.coordinates.latitude,addresses.first.coordinates.longitude),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 1))]);
      if (_controller != null) {
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            new CameraPosition(
              zoom: 16,
              //bearing: 192.8334901395799,
              target: LatLng(addresses.first.coordinates.latitude, addresses.first.coordinates.longitude),
              tilt: 0,
            ),
          ),
        );
      }
    } catch (e) {
      //print(e);
    }
  }

  void pauseCameraAnimation() {
    Timer(Duration(seconds: 20),(){
      cameraAnimation = !cameraAnimation ;
      update();
    });
    cameraAnimation  = !cameraAnimation;
    update();
  }

  chooseFromSelectedContacts(String Number){
    if(selectedContacts.contains(Number)){
      selectedContacts.remove(Number);
      update();
    }else{
      selectedContacts.add(Number);
      update();
    }
  }

  initializeSelectedContacts(){
    Box<Map> selected_contact_box = Hive.box<Map>("selected_contact_box");

    selected_contact_box.values.toList().forEach((element){
      selectedContacts.add(element['phones'].first['value'].replaceAll('-', '').replaceAll('+880', '0').replaceAll('+44','0').toString().replaceAll(' ',''));
      update();
    });
  }

  assignPrefs() async{
    prefs = await SharedPreferences.getInstance();

    if(prefs.getBool('enable_shake_detection')==null){
      await prefs.setBool('enable_shake_detection', false);
    }

    update();
  }

  // Create the polylines for showing the route between two places

  _createPolylines(Marker start, List<Marker> destinations) async {

    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // List of coordinates to join
    List<LatLng> polylineCoordinates = [];

    destinations.forEach((destination) async{
      // Generating the list of coordinates to be used for
      // drawing the polylines
      PolylineResult result;
      try{
        result = await polylinePoints.getRouteBetweenCoordinates(
          'AIzaSyAQBicVbY4o2H7w9ufjP0trTdxsVikfEjc',
          PointLatLng(start.position.latitude, start.position.longitude),
          PointLatLng(destination.position.latitude, destination.position.longitude),
          travelMode: TravelMode.driving,
        );
      }catch(err){
        //print('Error while drawing polyline: ' + err.toString());
      }

      // Adding the coordinates to the list
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
    });

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Color(0xff410DA2),
      points: polylineCoordinates,
      width: 6,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
    update();
  }

  //randomPolylines()

  enable_help_request_collection_listener(BuildContext context){
    try{

      if(help_request_collection_listener!=null){
        help_request_collection_listener.cancel();
      }

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

              Map<String,dynamic> data = {
                'id' : element.data()['requester_id'],
                'marker' : 'requester'
              };

              if(!others.contains(data)){
                others.add(data);
                update();
              }

            }else{

              Map<String,dynamic> data = {
                'id' : element.data()['helper_id'],
                'marker' : 'helper'
              };

              if(!others.contains(data)){
                others.add(data);
                update();
              }

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
      //print('Error while enabling help request collection listener: ' + error.toString());
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

          bool helper = true;

          others.forEach((others_element) {
            if(others_element['id']==element.data()['user_id'][0]){
              helper = (others_element['marker']== 'helper');
            }
          });

          Uint8List imageData;

          try{
            imageData = await getMarker(context, helper ? "assets/images/helper_marker.png" : "assets/images/help_seeker_marker.png");
          }catch(err){
            //print('error while setting image data: ' + err.toString());
          }

          otherMarkers.add(
              Marker(
                  infoWindow: InfoWindow(
                    title: element.data()['full_name'],
                  ),
                  markerId: MarkerId(element.data()['user_id'][0]),
                  position: LatLng(element.data()['g']['geopoint'].latitude,element.data()['g']['geopoint'].longitude),
                  draggable: false,
                  zIndex: 2,
                  flat: true,
                  anchor: Offset(0.5, 1),
                  icon: BitmapDescriptor.fromBytes(imageData))
          );
          update();
          if(!marker.isNull){
            _createPolylines(marker, otherMarkers);
          }
        });
      });
    }catch(error){
      otherMarkers.clear();
      update();
      //print('Error while enabling user collection listener: ' + error.toString());
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
      String one_signal_user_id = '';
      await OneSignal.shared.getPermissionSubscriptionState().then((status) {
        one_signal_user_id = status.subscriptionStatus.userId;
      });
      final CollectionReference users = FirebaseFirestore.instance.collection('Users');

      await users.doc(_userID).update(
        {
          'fcm' : fcmToken,
          'onesignal_user_id' : one_signal_user_id.trim()
        },
      );
    }catch(error){
      //print('error while updating fcm: ' + error);
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

  Future<void> askForHelp(BuildContext context) async {

    //to stop the user from constantly clicking
    pauseAskForHelp();

    if (_controller != null) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          new CameraPosition(
            zoom: 16,
            //bearing: 192.8334901395799,
            target: LatLng(users_current_location.latitude, users_current_location.longitude),
            tilt: 0,
          ),
        ),
      );
    }

    //getting the user's UID:
    final auth  = Provider.of<FirebaseAuthService>(context, listen: false);

    //getting helper's list:
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getHelpers');
    final results = await callable({'latitude': marker.position.latitude,'longitude':marker.position.longitude});
    List helpers = results.data;
   // print('helpers: ' + helpers.toString());

    //send help request notification example:
    helpers.forEach((element) async{


      if(element['id']!= auth.userInfo['user_id'][0]) { //User himself gets cut off from the list
        FirebaseFirestore.instance.doc('Users/${element['id']}').get().then((value) => {
          sendNotification(value.data()['fcm'],value.data()['onesignal_user_id'])
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
       // print('error while checking if helper is occupied: ' + error.toString());
      }

      if (!helper_occupied && auth.userInfo['user_id'][0] != element['id']) {
        helpRequests.doc('${auth.userInfo['user_id'][0]}_${element['id']}').set({
          'requester_id' : auth.userInfo['user_id'][0],
          'requester_name' : auth.userInfo['full_name'],
          'requester_image' : auth.userInfo['profile_image'],
          'helper_id' : element['id'],
          'req_status' : 'rejected',
          'requester_called_off' : false,
          'expire_date' : DateTime.now().add(Duration(days: 1)),
          'helper_and_requester': [auth.userInfo['user_id'][0], element['id']]
        });
      }
    });
  }

  sendNotification(String fcmToken, String oneSignalUserID) async{

    var notification = OSCreateNotification(
        playerIds: [oneSignalUserID],
        content: "Please open your locate me app to find out",
        heading: "Someone is in danger!!!",
        );

    var response = await OneSignal.shared.postNotification(notification);

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('sendRequestToHelpers');
    final results = await callable(fcmToken);
    //print('push status: ' + results.data.toString());
    //print('one signal push status' + response.toString());
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

  send_SMS_Location_To_Trusted_Contacts(BuildContext context){
    if(selectedContacts.isNotEmpty){
      final auth  = Provider.of<FirebaseAuthService>(context, listen: false);
      final CollectionReference helpRequests = FirebaseFirestore.instance.collection('HelpRequests');



      FirebaseFirestore.instance.collection('Users').where('phone_number', arrayContainsAny: selectedContacts).get().then((doc){

        List<String> existing_numbers = new List<String>();

        doc.docs.toList().forEach((element) async{
          existing_numbers.add(element.data()['phone_number'][1]);
          sendNotification(element.data()['fcm'],element.data()['onesignal_user_id']);
          await helpRequests.doc('${auth.userInfo['user_id'][0]}_${element.data()['user_id'][0]}').set({
            'requester_id' : auth.userInfo['user_id'][0],
            'requester_name' : auth.userInfo['full_name'],
            'requester_image' : auth.userInfo['profile_image'],
            'helper_id' : element.data()['user_id'][0],
            'req_status' : 'rejected',
            'requester_called_off' : false,
            'expire_date' : DateTime.now().add(Duration(days: 1)),
            'helper_and_requester': [auth.userInfo['user_id'][0], element.data()['user_id'][0]]
          });
        });

        //print('Existing Numbers:' + existing_numbers.toString());
        //print('Phone Numbers:' + selectedContacts.toString());

        selectedContacts.forEach((element){
         // print(!existing_numbers.contains(element));
          if(!existing_numbers.contains(element)){
            sendSMS(number: element,
                message: "${auth.userInfo['full_name']} may be in danger, he's current location is:\nhttps://www.google.com/maps/search/?api=1&query=${users_current_location.latitude},${users_current_location.longitude}");
          }else{
            sendSMS(number: element,
                message: "${auth.userInfo['full_name']} may be in danger, Please open your locate me app to see his/her live location");
          }
        });
      });
    }
  }

  void sendSMS({String number, String message}){
    try{
      SmsSender sender = new SmsSender();
      sender.sendSms(new SmsMessage(number, message));
    }catch(err){
     // print('Error while sending message: ' + err.toString());
    }
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

    circles = Set.from([Circle(
      circleId: CircleId("you"),
      center: latlng,
      radius: 500,
      strokeWidth: 2,
      strokeColor: Colors.lightBlueAccent,
      fillColor: Colors.lightBlueAccent.withOpacity(0.1)
    )]);

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

        users_current_location = newLocalData;

        updateMarkerAndCircle(newLocalData, imageData);

        if(updateLocation){
          updatingLocationOnFirebase(newLocalData);
          pauseLocationUpdate();
        }

        if(cameraAnimation){
          pauseCameraAnimation();
          //draw line:
          if(marker!=null && otherMarkers.isNotEmpty && !otherMarkers.isNull){
            _createPolylines(marker, otherMarkers);
          }
          //move camera:
          if (_controller != null) {
            _controller.animateCamera(
              CameraUpdate.newCameraPosition(
                new CameraPosition(
                  zoom: 16,
                  //bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                ),
              ),
            );
          }
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