import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

import 'package:sambl/utility/geo_point_utilities.dart';
import 'package:sambl/model/hawker_center.dart';


List<HawkerCenter> sortHawkerCenter(List<HawkerCenter> hawkerCenterList, GeoPoint location) {
  List<HawkerCenter> res = hawkerCenterList;
  res.sort((h1,h2) {
    if (getDistance(h1.location, location) - getDistance(h2.location, location) > 0) {
      return 1;
    } else if (getDistance(h1.location, location) - getDistance(h2.location, location) < 0) {
      return -1;
    } else {
      return 0;
    }
  });
  return res.take(12).toList();
}