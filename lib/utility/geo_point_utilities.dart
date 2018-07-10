import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haversine/haversine.dart';

Map<String,dynamic> geoPointToMap(GeoPoint point) {
  return {
  'latitude': point.latitude,
  'longitude': point.longitude
  };
}

// return distance in metres
double getDistance(GeoPoint p1, GeoPoint p2) {
  return new Haversine.fromDegrees(
    latitude1: p1.latitude,
    longitude1: p1.longitude,
    latitude2: p2.latitude,
    longitude2: p2.longitude)
    .distance();
}