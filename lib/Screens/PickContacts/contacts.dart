import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:locate_me/widgets/form-textfield.dart';
import 'package:permission_handler/permission_handler.dart';

import 'contacts_state_management.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  TextEditingController searchQuery;
  ContactStatecontroller _ContactStatecontroller =
  Get.put(ContactStatecontroller());

  @override
  void initState() {
    searchQuery = new TextEditingController();
    searchQuery.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: formTextfield(
          label: 'Search Contacts..',
          textController: searchQuery,
          inputType: TextInputType.text,
          hintText: 'By name or number..',
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                _ContactStatecontroller.onDone(context);
              },
              child: Container(
                child: Center(
                  child: Text("DONE",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                height: 50,
                width: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffF17350),
                      Color(0xffFF5050),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
        ),
        child: GetBuilder<ContactStatecontroller>(
          builder: (csm) {
            return ListView.builder(
              itemCount: csm.contact_list.length,
              itemBuilder: (context, index) {
                return csm.contact_list[index]['contact_info'].displayName.trim()
                            .toLowerCase()
                            .contains(
                              searchQuery.text.trim().toLowerCase(),
                            ) || csm.contact_list[index]['contact_info'].phones.first.value.trim()
                    .toLowerCase()
                    .contains(
                  searchQuery.text.trim().toLowerCase(),
                )
                    ? ContactListTile(contact: csm.contact_list[index])
                    : Container(
                     height: 0,
                     width: 0,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ContactListTile extends StatelessWidget {
  final Map contact;

  const ContactListTile({
    Key key,
    @required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContactStatecontroller _ContactStatecontroller =
        Get.put(ContactStatecontroller());

    return CheckboxListTile(
      activeColor: Color(0xfff49154),
      onChanged: (value) {
        _ContactStatecontroller.changeSelectedStat(contact['identifier']);
      },
      value: contact['selected'],
      secondary: CircleAvatar(
        radius: 60,
        backgroundColor: Color(0xfff49154),
        child: Text(
          contact['contact_info'].displayName.toUpperCase().substring(0, 1),
          style: TextStyle(color: Colors.white, fontSize: 38),
        ),
      ),
      title: Text(contact['contact_info'].displayName),
      subtitle: Text(contact['contact_info'].phones.first.value),
    );
  }
}
