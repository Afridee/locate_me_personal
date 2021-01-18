import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:locate_me/widgets/dialogue.dart';
import 'mapStateManagment.dart';

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
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        appShowDialog(context, message['notification']['title'],
            message['notification']['body'], Colors.green);
      },
      onLaunch: (Map<String, dynamic> message) async {
        appShowDialog(context, message['notification']['title'],
            message['notification']['body'], Colors.green);
      },
      onResume: (Map<String, dynamic> message) async {
        appShowDialog(context, message['notification']['title'],
            message['notification']['body'], Colors.green);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                    scrollGesturesEnabled: !MSC.shareLiveLocation,
                    minMaxZoomPreference: MinMaxZoomPreference(10, 18),
                    mapType: MapType.normal,
                    initialCameraPosition: _initialPosition,
                    markers: MSC.marker != null ? Set.of([MSC.marker] + MSC.otherMarkers) : null,
                    onMapCreated: (GoogleMapController controller) {
                      try{
                        controller.setMapStyle(_mapStyle);
                        mapStatecontroller.setController(controller);
                      }catch(error){
                        print('error while initializing map: ' + error.toString());
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
                              GetBuilder<MapStatecontroller>(builder: (LSC) {
                                return AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  height: 40.0,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: LSC.shareLiveLocation
                                          ? Colors.greenAccent[100]
                                          : Colors.redAccent[100]),
                                  child: Stack(
                                    children: <Widget>[
                                      AnimatedPositioned(
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeIn,
                                        top: 3.0,
                                        left:
                                            LSC.shareLiveLocation ? 30.0 : 0.0,
                                        right:
                                            LSC.shareLiveLocation ? 0.0 : 30.0,
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
                                                    Icons.remove_circle_outline,
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
                              })
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Color(0xff410DA2)),
                        width: MediaQuery.of(context).size.width - 105,
                        height: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GetBuilder<MapStatecontroller>(
                        builder: (LSC){
                          return InkWell(
                            onTap: () {
                              if(LSC.askForHelpButtonClickable){
                                mapStatecontroller.askForHelp();
                              }
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                  LSC.askForHelpButtonClickable ? "ASK FOR HELP" : "WAIT, FINDING HELP..",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              decoration: BoxDecoration(
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
                builder: (context){
                  return context.shareLiveLocation ? SpinKitRipple(
                    color: Color(0xff410DA2),
                    size: 60.0,
                  ) : Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
