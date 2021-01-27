import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
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
                  "Privacy Policy",
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
                        "Your privacy is important to us. It is Team Oreo's policy to respect your privacy.\n\nregarding any information we may collect from you across our website- ",
                      ),
                      TextSpan(
                        text: 'https://www.oreostudio.com/',
                        // style: new TextStyle(color: Colors.blue),
                        // recognizer: new TapGestureRecognizer()
                        //   ..onTap = () {
                        //     launch('https://www.oreostudio.com/');
                        //   },
                      ),
                      TextSpan(
                        text:
                        " and other sites we own and operate.\n\nWe only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. We also let you know why we’re collecting it and how it will be used.\nWe only retain collected information for as long as necessary to provide you with your requested service. What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorised access, disclosure, copying, use or modification.\n\nWe don’t share any personally identifying information publicly or with third parties, except when required to by law.\nOur website may link to external sites that are not operated by us. Please be aware that we have no control over the content and practices of these sites and cannot accept responsibility or liability for their respective privacy policies. You are free to refuse our request for your personal information, with the understanding that we may be unable to provide you with some of your desired services.\nYour continued use of our website will be regarded as acceptance of our practicesaround privacy and personal information. If you have any questions about how we handle user data and personal information feel free to contact us.\n\nThis policy is effective as of 1 November 2019.",
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