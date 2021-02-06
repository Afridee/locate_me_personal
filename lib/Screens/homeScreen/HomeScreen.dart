import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show SystemChrome, rootBundle;
import 'package:locate_me/Screens/helpRequests/help_requests.dart';
import 'package:locate_me/widgets/help_request_dialogue.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/Drawer.dart';
import 'ChooseContactsToShareLive.dart';
import 'mapStateManagment.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:locate_me/models/RequestModel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  PageController pageController;
  int PageIndex = 0;
  String _mapStyle;
  MapStatecontroller mapStatecontroller;
  final CameraPosition _initialPosition = CameraPosition(target: LatLng(23.6850, 90.3563));
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StreamSubscription stream1;
  StreamSubscription stream2;
  SharedPreferences prefs;
  ShakeDetector detector;

  enable_shake() async{
    prefs = await SharedPreferences.getInstance();
    detector = ShakeDetector.waitForStart(
        onPhoneShake: () {
          if(prefs.getBool('enable_shake_detection')){
            if(mapStatecontroller.askForHelpButtonClickable){
              mapStatecontroller.askForHelp(context);
            }
          }
        }
    );
    detector.startListening();
  }


  navBarOnTap(int pageIndex) {

    setState(() {
      PageIndex==0? PageIndex = 1 : PageIndex = 0;
    });

    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }


  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    mapStatecontroller = Get.put(MapStatecontroller(context));
    enable_shake();
    mapStatecontroller.getCurrentLocation(context);
    try {
      stream2 = FirebaseFirestore.instance
          .collection('HelpRequests')
          .where('helper_id',
          isEqualTo: fba.FirebaseAuth.instance.currentUser.uid)
          .where('requester_called_off', isEqualTo: false)
          .where('req_status',isEqualTo: 'rejected')
          .snapshots()
          .listen((event) {
        event.docs.toList().forEach((element) {
          if(DateTime.now().isBefore(DateTime.fromMicrosecondsSinceEpoch(element.data()['expire_date'].microsecondsSinceEpoch))){
            appShowHelpDialog(context, RequestModel.fromJson(element.data()));
          }
        });
      },
      );
    } catch (err) {
      print('Error in HelpRequests init: ' + err.toString());
    }
    try {
      stream1 = FirebaseFirestore.instance
          .collection('HelpRequests')
          .where('helper_and_requester',
              arrayContains: fba.FirebaseAuth.instance.currentUser.uid)
          .where('req_status', isEqualTo: 'accepted')
          .where('requester_called_off', isEqualTo: false)
          .snapshots()
          .listen((event) {
        mapStatecontroller.enable_help_request_collection_listener(context);
      });
    } catch (err) {
      print('Error in Homescreen init: ' + err.toString());
    }
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('msg recieved from onMessage');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('msg recieved from onLaunch');
      },
      onResume: (Map<String, dynamic> message) async {
        print('msg recieved from onResume');
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    if(!stream1.isNull){
      stream1.cancel();
    }
    if(!stream2.isNull){
      stream2.cancel();
    }
    if(!mapStatecontroller.help_request_collection_listener.isNull){
      mapStatecontroller.help_request_collection_listener.cancel();
    }
    if(!mapStatecontroller.user_collection_listener.isNull){
      mapStatecontroller.user_collection_listener.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xffF26F50)),
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
        ),
        endDrawer: SideDrawer(),
        body: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                GetBuilder<MapStatecontroller>(
                  builder: (MSC) {
                    return GoogleMap(
                      polylines: MSC.polylines != null
                          ? Set<Polyline>.of(MSC.polylines.values)
                          : null,
                      scrollGesturesEnabled: MSC.askForHelpButtonClickable,
                      minMaxZoomPreference: MinMaxZoomPreference(10, 18),
                      mapType: MapType.normal,
                      initialCameraPosition: _initialPosition,
                      markers: MSC.marker != null
                          ? Set.of([MSC.marker] + MSC.otherMarkers)
                          : null,
                      onMapCreated: (GoogleMapController controller) {
                        try {
                          controller.setMapStyle(_mapStyle);
                          mapStatecontroller.setController(controller);
                        } catch (error) {
                          print('error while initializing map: ' +
                              error.toString());
                        }
                      },
                    );
                  },
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            var route = new MaterialPageRoute(
                              builder: (BuildContext context) => new ChooseContactsToShareLive(),
                            );
                            Navigator.of(context).push(route);
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                "SHARE LIVE LOCATION",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xff410DA2).withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: Offset(0, 2), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(30),
                                color: Color(0xff410DA2)),
                            width: MediaQuery.of(context).size.width - 105,
                            height: 50,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GetBuilder<MapStatecontroller>(
                          builder: (LSC) {
                            return InkWell(
                              onTap: () {
                                if (LSC.askForHelpButtonClickable) {
                                  mapStatecontroller.askForHelp(context);
                                }
                              },
                              child: Container(
                                child: Center(
                                  child: Text(
                                    LSC.askForHelpButtonClickable
                                        ? "ASK FOR HELP"
                                        : "WAIT, FINDING HELP..",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xffF26F50).withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: Offset(0, 2), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(30),
                                    color: Color(0xffF26F50)),
                                width: MediaQuery.of(context).size.width - 105,
                                height: 50,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 55,
                      )
                    ],
                  ),
                ),
                GetBuilder<MapStatecontroller>(
                  builder: (context) {
                    return ! context.askForHelpButtonClickable
                        ? SpinKitRipple(
                      color: Color(0xff410DA2),
                      size: 60.0,
                    )
                        : Container();
                  },
                ),
              ],
            ),
          ),HelpRequests()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: PageIndex,
          onTap: (index){
            navBarOnTap(index);
          },
          selectedItemColor: Color(0xffF26F50),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Requests'
            )
          ],
        ),
      ),
    );
  }
}


