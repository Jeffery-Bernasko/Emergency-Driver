import 'dart:async';

import 'package:driver_app/AllScreens/loginScreen.dart';
import 'package:driver_app/AllWidgets/ConfigMaps.dart';
import 'package:driver_app/Assistants/assistantMethods.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatelessWidget {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  Position currentPosition;
  var geoLocator = Geolocator();

  String driverStatus = "Offline";
  Color driverStatusColor = Colors.black;
  bool isDriverOnline = false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //String address = await AssistantMethods.searchCoordinateAddress(position, context);
    //print("this is your address " + address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Main Screen'),
      ),
      drawer: Container(
        width: 255.0,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            children: [
              //Drawer Header
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset("images/user_icon.png",
                          height: 65.0, width: 65.0),
                      SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Profile Name",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            'View Profile',
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                color: Colors.black54,
                thickness: 1.0,
              ),
              SizedBox(
                height: 12.0,
              ),
              // Drawer Body Controllers
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  "Ride History",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "View Profile",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),

              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    "Log Out",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              locatePosition();
            },
          ),

          //drivers status

          Container(
            height: 140.0,
            width: double.infinity,
            color: Colors.black54,
          ),

          Positioned(
            top: 60.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: RaisedButton(
                    onPressed: () async {
                      makeDriverOnline();
                      getLiveLocationUpdates();
                    },
                    color: driverStatusColor,
                    child: Padding(
                      padding: EdgeInsets.all(17.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            driverStatus,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Icon(
                            Icons.phone_android,
                            color: Colors.white,
                            size: 26.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void makeDriverOnline() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availabeDrivers");
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);

    rideRequestRef.onValue.listen((event) {});
  }

  void getLiveLocationUpdates() async {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      Geofire.setLocation(
          currentfirebaseUser.uid, position.latitude, position.longitude);
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
