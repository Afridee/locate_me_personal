import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:picker/picker.dart';
import 'package:path/path.dart';

class ReportStateController extends GetxController {
  String location = '...';
  String Scene = '...';
  List<File> Files = new List<File>();
  bool reportButtonActivated = true;

  void pausereportButton() {
     Timer(Duration(seconds: 10),(){
        reportButtonActivated = !reportButtonActivated ;
        update();
     });
     reportButtonActivated  = !reportButtonActivated;
     update();
  }

  void getImageFromGallery() async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      try {
        var imageFile = await Picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 700,
          maxHeight: 700,
        );
        Files.add(imageFile);
        update();
      } catch (error) {
        //print('Error while getting image : ' + error.toString());
      }
    }
  }

  void getImageFromCamera() async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      try {
        var imageFile = await Picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 700,
          maxHeight: 700,
        );
        Files.add(imageFile);
        update();
      } catch (error) {
        //print('Error while getting image : ' + error.toString());
      }
    }
  }

  void delete({File file}) {
    Files.remove(file);
    update();
  }

  void Report({@required Map userInfo}) async{
    if (Scene.length > 5 && location.length > 5 && reportButtonActivated) {

       pausereportButton();

      List<String> urls = new List<String>();

      await Files.forEach((file) {
        //getting the image name:
        String fileName = basename(file.path);

        //setting up a reference for firebase storage:
        firebase_storage.Reference firebaseStorageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('reported_images/$fileName');

        //uploading the image:
        firebase_storage.UploadTask uploadTask =
            firebaseStorageRef.putFile(file);

        //Checking upload status:
        uploadTask.snapshotEvents.listen(
            (firebase_storage.TaskSnapshot snapshot) {
          //print('Task state: ${snapshot.state}');
          //print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
        }, onError: (e) {
          if (e.code == 'permission-denied') {
            //print('User does not have permission to upload to this reference.');
          }
        });

        //add url to List:
        uploadTask.whenComplete(() async {
          try {
            String downloadURL = await firebaseStorageRef.getDownloadURL();
            urls.add(downloadURL);

            if(urls.length.isEqual(Files.length)){
              final CollectionReference Reports = FirebaseFirestore.instance.collection('Reports');
              Reports.add({'location': location, 'scene : ': Scene, 'images': urls, 'reporter' : userInfo});
            }

          } catch (e) {
            //print(e);
          }
        });
      });
    }
  }

  getLocation({@required TextEditingController controller}) async{
    Location _locationTracker = Location();
    final LocationData localData = await _locationTracker.getLocation();
    final coordinates = new Coordinates(localData.latitude, localData.longitude);
    final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    final first = addresses.first;
    controller.text = first.addressLine;
    location = first.addressLine;
  }
}
