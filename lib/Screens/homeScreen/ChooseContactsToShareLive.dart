import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'ChooseContactsToShareLiveListTile.dart';
import 'mapStateManagment.dart';

class ChooseContactsToShareLive extends StatefulWidget {
  ChooseContactsToShareLive({Key key}) : super(key: key);

  @override
  _ChooseContactsToShareLiveState createState() => _ChooseContactsToShareLiveState();
}

class _ChooseContactsToShareLiveState extends State<ChooseContactsToShareLive> {

  Box<Map> selected_contact_box;
  MapStatecontroller mapStatecontroller;

  @override
  void initState() {
    mapStatecontroller = Get.put(MapStatecontroller(context));
    selected_contact_box = Hive.box<Map>("selected_contact_box");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              child: ValueListenableBuilder(
                valueListenable: selected_contact_box.listenable(),
                builder: (context, Box<Map> selectedcontactbox, _) {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                          return ChooseContactsToShareLiveListTile(contact:  selectedcontactbox.values.toList()[index]);
                      },
                      separatorBuilder: (_, index) => Divider(),
                      itemCount: selectedcontactbox.keys.toList().length);
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: InkWell(
                  onTap: (){
                    mapStatecontroller.send_SMS_Location_To_Trusted_Contacts(context);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    child: Center(
                        child: Text(
                          'Send',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        )),
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff410DA2).withOpacity(0.5),
                          spreadRadius: 0.1,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Color(0xff410DA2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}