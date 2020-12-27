import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/form-textfield.dart';
import 'form_state_management.dart';

class form extends StatefulWidget {
  @override
  _formState createState() => _formState();
}

class _formState extends State<form> {
  TextEditingController name_controller;
  FormStatecontroller formStatecontroller = Get.put(FormStatecontroller());

  @override
  void initState() {
    name_controller = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    name_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/locate_me_icon.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Locate Me',
              style: TextStyle(color: Color(0xff1C2D69)),
            )
          ],
        ),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Color(0xffffffff)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'Personal Information',
                style: TextStyle(
                    color: Color(0xfff49154),
                    fontSize: 28,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: (){
                   formStatecontroller.getImage();
                },
                child: ClipOval(
                  child: GetBuilder<FormStatecontroller>(
                    builder: (context){
                      return context.imageFile.isNull? Image.asset(
                        "assets/images/camera.png",
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      ) : Image.file(context.imageFile,
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Upload a profile picture',
              style: TextStyle(
                  color: Color(0xff1C2D69),
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
            formTextfield(
              hintText: 'John Doe',
              textController: name_controller,
              inputType: TextInputType.name,
              label: 'Enter your full name',
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: (){
                  formStatecontroller.updateUserInfo(context, name_controller.text);
                },
                child: Container(
                  child: Center(
                    child: GetBuilder<FormStatecontroller>(
                      builder: (context){
                        return Text(
                          context.update_button_activated? 'PROCEED' : 'UPDATING.....',
                          style: TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  height: 40,
                  width: 543,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffF17350),
                        Color(0xffFF5050),
                      ]),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
