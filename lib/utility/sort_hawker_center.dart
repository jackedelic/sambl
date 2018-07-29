import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

import 'package:sambl/utility/geo_point_utilities.dart';
import 'package:sambl/model/hawker_center.dart';


Future<List<HawkerCenter>> sortHawkerCenter(List<HawkerCenter> hawkerCenterList, Future<GeoPoint> location) {
  return location.then((loc) {
    List<HawkerCenter> res = hawkerCenterList;
    res.sort((h1,h2) {
      if (getDistance(h1.location, loc) - getDistance(h2.location, loc) > 0) {
        return 1;
      } else if (getDistance(h1.location, loc) - getDistance(h2.location, loc) < 0) {
        return -1;
      } else {
        return 0;
      }
    });
    return res.take(12).toList();
  });
}