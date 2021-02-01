import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'mapStateManagment.dart';


class ChooseContactsToShareLiveListTile extends StatefulWidget {
  final Map contact;

  const ChooseContactsToShareLiveListTile({
    Key key,
    @required this.contact,
  }) : super(key: key);

  @override
  _ChooseContactsToShareLiveListTileState createState() => _ChooseContactsToShareLiveListTileState();
}

class _ChooseContactsToShareLiveListTileState extends State<ChooseContactsToShareLiveListTile> {

  MapStatecontroller mapStatecontroller;

  @override
  void initState() {
    mapStatecontroller = Get.put(MapStatecontroller(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  Container(
      child: GetBuilder<MapStatecontroller>(
          builder: (MSC) {
              return InkWell(
                onTap: (){
                  String number = widget.contact['phones'].first['value'].replaceAll('-', '').replaceAll('+880', '0').replaceAll('+44','0').toString().replaceAll(' ','');
                  mapStatecontroller.chooseFromSelectedContacts(number);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xfff49154),
                    child: Text(
                      widget.contact['displayName'].toUpperCase().substring(0, 1),
                      style: TextStyle(color: Colors.white, fontSize: 38),
                    ),
                  ),
                  trailing: MSC.selectedContacts.contains(widget.contact['phones'].first['value'].replaceAll('-', '').replaceAll('+880', '0').replaceAll('+44','0').toString().replaceAll(' ','')) ?
                   Icon(Icons.check_circle, color: Colors.green,) : Container(height: 0,width: 0,),
                  title: Text(widget.contact['displayName']),
                  subtitle: Text(widget.contact['phones'][0]['value']),
                ),
              );
          }),
    );
  }
}