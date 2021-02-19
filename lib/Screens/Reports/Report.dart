import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:locate_me/Screens/Reports/ReportStateController.dart';
import 'package:locate_me/Screens/loginPages/firebase_auth_service.dart';
import 'package:locate_me/widgets/bottom-painter.dart';
import 'package:locate_me/widgets/custom-painter.dart';
import 'package:locate_me/widgets/dialogue.dart';
import 'package:provider/provider.dart';


class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {

  TextEditingController LocationController;

  @override
  void initState() {
    LocationController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    LocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final auth  = Provider.of<FirebaseAuthService>(context, listen: false);

    ReportStateController reportStateController = Get.put(ReportStateController());

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
       appBar: buildAppBar(context),
       body: Container(
         height: MediaQuery.of(context).size.height,
         width: MediaQuery.of(context).size.width,
         child: ListView(
           children: [
             Padding(
               padding: const EdgeInsets.all(15.0),
               child: Container(
                 child: Column(
                   children: [
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: Text(
                           'Choose Image from :',
                           style: TextStyle(
                             fontWeight: FontWeight.bold
                           ),
                       ),
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         CircleAvatar(
                           backgroundColor: Color(0xff410DA2),
                           radius: 20,
                           child: IconButton(
                             onPressed: (){
                               reportStateController.getImageFromCamera();
                             },
                             color: Colors.white,
                             icon: Icon(Icons.camera_alt),
                           ),
                         ),
                         Text("or"),
                         CircleAvatar(
                           backgroundColor: Color(0xff410DA2),
                           radius: 20,
                           child: IconButton(
                             onPressed: (){
                               reportStateController.getImageFromGallery();
                             },
                             color: Colors.white,
                             icon: Icon(Icons.image),
                           ),
                         ),
                       ],
                     ),
                     SizedBox(
                       height: 2,
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(
                         height: 40,
                         child: GetBuilder<ReportStateController>(
                           builder: (rsc){
                             return ListView.builder(
                               scrollDirection: Axis.horizontal,
                               itemCount: rsc.Files.length,
                               itemBuilder: (context, index){
                                 return ReportImageFile(file : rsc.Files[index]);
                               },
                             );
                           },
                         )
                       ),
                     )
                   ],
                 ),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.grey.withOpacity(0.5),
                       spreadRadius: 1,
                       blurRadius: 7,
                       offset: Offset(0, 2), // changes position of shadow
                     ),
                   ],
                 color: Colors.white,
                 ),

               ),
             ),
             Padding(
               padding: const EdgeInsets.all(15.0),
               child: Container(
                 padding: EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.grey.withOpacity(0.5),
                       spreadRadius: 1,
                       blurRadius: 7,
                       offset: Offset(0, 2), // changes position of shadow
                     ),
                   ],
                   color: Colors.white,
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Container(
                       width: 250,
                       height: 40,
                       child: TextField(
                         controller: LocationController,
                         maxLines: 2,
                         decoration: InputDecoration(
                           hintText: "What location was this in....",
                           border: InputBorder.none,
                         ),
                         onChanged: (value){
                            reportStateController.location = value;
                         },
                       ),
                     ),
                     InkWell(
                       onTap: (){
                         reportStateController.getLocation(controller: LocationController);
                       },
                       child: Container(
                         child: Center(
                           child: Image(
                             image: AssetImage("assets/images/locate_me_icon.png"),
                             width: 20,
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(15.0),
               child: Container(
                 padding: EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.grey.withOpacity(0.5),
                       spreadRadius: 1,
                       blurRadius: 7,
                       offset: Offset(0, 2), // changes position of shadow
                     ),
                   ],
                   color: Colors.white,
                 ),
                 child: TextField(
                   maxLines: 7,
                   decoration: InputDecoration(
                     hintText: "Explain the scene...",
                     border: InputBorder.none,
                   ),
                   onChanged: (value){
                       reportStateController.Scene = value;
                   },
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(10.0),
               child: InkWell(
                 onTap: (){
                   reportStateController.Report(userInfo: auth.userInfo);
                   Navigator.of(context).pop();
                   appShowDialog(context, "Your report has been submitted", "We will reach you shortly", Color(0xff410DA2));
                 },
                 child: Container(
                   height: 50,
                   child: Center(
                     child: Text(
                       'Report',
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 15
                       ),
                     ),
                   ),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     boxShadow: [
                       BoxShadow(
                         color: Color(0xff410DA2).withOpacity(0.5),
                         spreadRadius: 1,
                         blurRadius: 7,
                         offset: Offset(0, 2), // changes position of shadow
                       ),
                     ],
                     color: Color(0xff410DA2),
                   ),
                 ),
               ),
             ),
             Container(
               height: 20,
               child: Center(
                 child: Text("**This feature is not yet available", style: TextStyle(
                   color: Colors.grey.withOpacity(0.8)
                 ),)

               ),
             ),
             SizedBox(
               height: 30,
             ),
             Container(
               height: 80,
               child:  Stack(
                 children: [
                   BottomPainter(
                     top:
                     0,
                     painter: LightVioletCustomPaint(),
                   ),
                   BottomPainter(
                     top:
                     0,
                     painter: VioletCustomPaint(),
                   ),
                 ],
               ),
             )
           ],
         ),
       ),
    );
  }
}

class ReportImageFile extends StatelessWidget {

  final File file;

  const ReportImageFile({
    Key key,@required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ReportStateController reportStateController = Get.put(ReportStateController());

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff410DA2),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.attach_file,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  file.path.split('/').last,
                   style: TextStyle(
                     color: Colors.white
                   ),
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: (){
                    reportStateController.delete(file: file);
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Color(0xffF26F50)),
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Image(
                image: AssetImage("assets/images/locate_me_icon.png"),
                width: 15,
              ),
            ),
            TextSpan(
              text: "  Locate Me",
              style: TextStyle(
                color: Color(0xff1C2D69),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ));
}
