import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

String mapKey = "AIzaSyDoWSObQL_A27DQ_LjbXJmwNtmw1AWtuec";

User firebaseUser;

Users userCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;
