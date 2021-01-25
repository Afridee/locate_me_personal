import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/RequestModel.dart';

class requestListTile extends StatelessWidget {
  const requestListTile({
    Key key,
    @required this.request,
  }) : super(key: key);

  final RequestModel request;

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
                request.requesterImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            request.requesterName,
            style: TextStyle(fontSize: 20),
          ),
          trailing: InkWell(
            onTap: (){
              try{
                final CollectionReference helpRequests = FirebaseFirestore.instance.collection('HelpRequests');

                helpRequests.doc('${request.requesterId}_${request.helperId}').update({
                  'req_status' : request.reqStatus=='rejected' ? 'accepted' : 'rejected'
                });

              }catch(error){
                 print( 'Error while accepting request' + error.toString());
              }
            },
            child: Container(
              child: Center(
                child: Text(
                  request.reqStatus=='rejected'? 'accept' : 'accepted',
                  style: TextStyle(color:request.reqStatus=='rejected'? Colors.green : Colors.white),
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
                color:request.reqStatus=='rejected'? Colors.white : Colors.green,
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