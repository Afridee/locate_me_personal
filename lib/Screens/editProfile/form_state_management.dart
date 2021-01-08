import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import '../../Screens/loginPages/firebase_auth_service.dart';
import '../../widgets/dialogue.dart';
import 'package:picker/picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class FormStatecontroller extends GetxController {

  File imageFile;
  bool update_button_activated = true;
  Location _locationTracker = Location();

  void getImage() async {

    final status = await Permission.storage.request();

    if (status.isGranted) {
      try {
        imageFile = await Picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 700,
          maxHeight: 700,
        );
        update();
      } catch (error) {
        print('Error while getting image : ' + error.toString());
      }
    }
  }

  void updateUserInfo(BuildContext context, String full_name) async {
    if (update_button_activated && !imageFile.isNull && full_name.length > 5) {

      //first deactivate the button, so that the user doesn't keep clicking it like a little bitch:
      update_button_activated = false;
      update();

      //getting the image name:
      String fileName = basename(imageFile.path);

      //getting the user's UID:
      final auth = fba.FirebaseAuth.instance;
      final fba.User user = auth.currentUser;
      String _userID = user.uid;

      //setting up a reference for firebase storage:
      firebase_storage.Reference firebaseStorageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/$_userID/' + fileName);

      //uploading the image:
      firebase_storage.UploadTask uploadTask =
          firebaseStorageRef.putFile(imageFile);

      //Checking upload status:
      uploadTask.snapshotEvents.listen(
          (firebase_storage.TaskSnapshot snapshot) {
        print('Task state: ${snapshot.state}');
        print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      }, onError: (e) {
        update_button_activated = true;
        update();
        if (e.code == 'permission-denied') {
          print('User does not have permission to upload to this reference.');
        }
      });

      //get the image URL:
      uploadTask.whenComplete(() async {
        try {
          String downloadURL = await firebaseStorageRef.getDownloadURL();

          //Making a FirebaseAuthService instance to update unserInfo in provider:
          final auth = Provider.of<FirebaseAuthService>(context, listen: false);

          //Updating/Adding userInfo in firebase Database:
          final status = await Permission.location.request();
          final CollectionReference users = FirebaseFirestore.instance.collection('Users');
          final LocationData localData = await _locationTracker.getLocation();
          final geo = Geoflutterfire();
          GeoFirePoint myLocation = geo.point(latitude: localData.latitude, longitude: localData.longitude);
          await users.doc(_userID).set(
            {
              'full_name': full_name,
              'profile_image': downloadURL,
              'phone_number': user.phoneNumber,
              'user_id': _userID,
              'g' : status.isGranted? myLocation.data : geo.point(latitude: 0.00, longitude: 0.00).data
            },
          );

          //update unserInfo in provider:
          auth.getCurrentUserINFO();

          //activating the button again:
          update_button_activated = true;
          update();
        } catch (e) {
          update_button_activated = true;
          update();
          print('Error while getting download url and updating user info: ' +
              e.toString());
          }
      });
    }else{
      if(imageFile.isNull){
        appShowDialog(context, 'Image not selected', '...', Color(0xffF17350));
      }
      if(full_name.length < 5){
        appShowDialog(context, 'Invalid Name', 'Please enter your full name', Color(0xffF17350));
      }
      if(!update_button_activated){
        appShowDialog(context, 'Hold your horses, you already clicked', '...', Color(0xffF17350));
      }
    }
  }
}
