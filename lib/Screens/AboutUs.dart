import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
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
                  "About Us",
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
                        "Team Oreo UK LTD is a software development company located in London, United Kingdom. It’s also part of Oreo Studio.\n\nConcept by Ahammed Anshad, Design and developed by Team Oreo.\n\nProject Coordinate by – Mohammed Hadi, Director of Team Oreo UK Ltd\n\n",
                      ),
                      TextSpan(
                        text: 'Copyright © 2020 by Team Oreo UK LTD\n\n',
                        // style: new TextStyle(color: Colors.blue),
                        // recognizer: new TapGestureRecognizer()
                        //   ..onTap = () {
                        //     launch('https://www.oreostudio.com/');
                        //   },
                      ),
                      TextSpan(
                        text:
                        "All rights reserved. No part of this publication may be reproduced, distributed, or transmitted in any form or by any means, including photocopying, recording, or other electronic or mechanical methods, without the prior written permission of the publisher, except in the case of brief quotations embodied in critical reviews and certain other non-commercial uses permitted by copyright law. For permission requests, write to the publisher, addressed “Attention: Permissions Coordinator,” at the address below.\n\n",
                      ),
                      TextSpan(
                          text:
                          "Team Oreo UK LTD\n",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                        text:
                        "Newham, London\nUnited Kingdom, E16\nwww.oreostudio.com",
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