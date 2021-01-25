import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../widgets/Drawer.dart';
import '../../widgets/dialogue.dart';
import 'mapStateManagment.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _mapStyle;
  MapStatecontroller mapStatecontroller;
  final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(23.6850, 90.3563));
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  void initState() {
    mapStatecontroller = Get.put(MapStatecontroller(context));
    mapStatecontroller.getCurrentLocation(context);
    try {
      FirebaseFirestore.instance
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
        appShowDialog(context, message['notification']['title'],
            message['notification']['body'], Colors.red);
      },
      onLaunch: (Map<String, dynamic> message) async {
        appShowDialog(context, message['notification']['title'],
            message['notification']['body'], Colors.red);
      },
      onResume: (Map<String, dynamic> message) async {
        appShowDialog(context, message['notification']['title'],
            message['notification']['body'], Colors.red);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xff410DA2),
          shadowColor: Color(0xff410DA2),
        ),
        endDrawer: SideDrawer(),
        body: Container(
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
                    scrollGesturesEnabled: !MSC.shareLiveLocation,
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
                      child: Container(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "SHARE LIVE LOCATION",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              GetBuilder<MapStatecontroller>(
                                builder: (LSC) {
                                  return AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    height: 40.0,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: LSC.shareLiveLocation
                                            ? Colors.greenAccent[100]
                                            : Colors.redAccent[100]),
                                    child: Stack(
                                      children: <Widget>[
                                        AnimatedPositioned(
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.easeIn,
                                          top: 3.0,
                                          left: LSC.shareLiveLocation
                                              ? 30.0
                                              : 0.0,
                                          right: LSC.shareLiveLocation
                                              ? 0.0
                                              : 30.0,
                                          child: InkWell(
                                            onTap: () {
                                              mapStatecontroller
                                                  .toggleButton_for_shareLive();
                                              if (LSC.shareLiveLocation) {
                                                appShowDialog(
                                                    context,
                                                    'Live Location On',
                                                    'Your location is being shared with your trusted contacts',
                                                    Color(0xff410DA2));
                                              }
                                            },
                                            child: AnimatedSwitcher(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              transitionBuilder: (Widget child,
                                                  Animation<double> animation) {
                                                return RotationTransition(
                                                  child: child,
                                                  turns: animation,
                                                );
                                              },
                                              child: LSC.shareLiveLocation
                                                  ? Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                      size: 35.0,
                                                      key: UniqueKey(),
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .remove_circle_outline,
                                                      color: Colors.red,
                                                      size: 35.0,
                                                      key: UniqueKey(),
                                                    ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
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
                  return context.shareLiveLocation
                      ? SpinKitRipple(
                          color: Color(0xff410DA2),
                          size: 60.0,
                        )
                      : Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


