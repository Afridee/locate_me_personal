import 'dart:io';
import 'package:get/get.dart';
import 'package:picker/picker.dart';
import 'package:permission_handler/permission_handler.dart';


class FormStatecontroller extends GetxController{

   File imageFile;


  void getImage() async{
     try{

       final status = await Permission.storage.request();

       if(status.isGranted){
         imageFile = await Picker.pickImage(
           source: ImageSource.gallery,
           maxWidth: 5000,
           maxHeight: 5000,
         );
         update();
       }

     }catch(error){
       print('Error while getting image: ' + error.toString());
     }
  }
}