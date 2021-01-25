import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:locate_me/widgets/form-textfield.dart';
import 'ContactListTile.dart';
import 'contacts_state_management.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  TextEditingController searchQuery;
  ContactStatecontroller _ContactStatecontroller;


  @override
  void initState() {
    _ContactStatecontroller = Get.put(ContactStatecontroller());
    _ContactStatecontroller.getContacts();
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

