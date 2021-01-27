import 'package:flutter/material.dart';

class UserGuideline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 10.0,
                ),
                child: Text(
                  "User Guidelines",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xffF49154),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    // text: 'Hello ',
                    style: TextStyle(color: Colors.black),

                    children: <TextSpan>[
                      TextSpan(
                        text:
                        "Locate me is a location based mobile application which allow user to share their live location in case of an emergency.\n\nThis app designed for helping people those who’re in trouble. This app will let them know the exact location of the user with the help of some advanced features like burst detection or shake detection. This will help a mobile user to send their live location to the loved ones or any other person in the case of an emergency.\n\n",
                      ),
                      TextSpan(
                        text: 'Enable location-access: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        "user should allow location access to find their current location.\n\n",
                      ),
                      TextSpan(
                        text: 'Enable contact-access: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        "user should allow contact access to get into the phone book and choose 3-5 emergency contacts.\n\n",
                      ),
                      TextSpan(
                        text: 'Enable shake detection: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        "Enabling the shake detection will allow the user to shake their phone (without manually opening the app) to send their live location\n\n",
                      ),
                      TextSpan(
                        text: 'Ask for Help: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                        "It will send notification nearest people, help them to know, someone is in trouble and help them immediately. It will show user where exactly they are, and user can see how long that will take them to reach there. Another user can accept and reject the request if they aren’t available.",
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color(0xff959595),
          size: 16,
        ),
        onPressed: () => Navigator.pop(context),
      ),
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