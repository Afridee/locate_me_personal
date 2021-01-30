import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/RequestModel.dart';

class requestListTile extends StatefulWidget {
  const requestListTile({
    Key key,
    @required this.request,
  }) : super(key: key);

  final RequestModel request;

  @override
  _requestListTileState createState() => _requestListTileState();
}

class _requestListTileState extends State<requestListTile> {

  String LocationName = 'Loading...';

  setLocationName() async{
    LocationName = await widget.request.getRequesterLocationName();
    setState(() {});
  }

  @override
  void initState() {
    setLocationName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            height: 50,
            width: 50,
            child: ClipOval(
              child: Image.network(
                widget.request.requesterImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            widget.request.requesterName,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              LocationName,
              style: TextStyle(fontSize: 10),
            ),
          ),
          trailing: InkWell(
            onTap: (){
                widget.request.AcceptRejectToggle();
            },
            child: Container(
              child: Center(
                child: Text(
                  widget.request.reqStatus=='rejected'? 'accept' : 'accepted',
                  style: TextStyle(color:widget.request.reqStatus=='rejected'? Colors.green : Colors.white),
                ),
              ),
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
                color:widget.request.reqStatus=='rejected'? Colors.white : Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            height: 30,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}