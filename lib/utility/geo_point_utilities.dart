import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haversine/haversine.dart';
import 'package:location/location.dart';

import 'package:geocoder/geocoder.dart';

Future<String> reverseGeocode(GeoPoint point) {
  return Geocoder.local.findAddressesFromCoordinates(new Coordinates(point.latitude, point.longitude)).then((list) {
    return list.first.addressLine;
  });
}

Map<String,dynamic> geoPointToMap(GeoPoint point) {
  return {
  'latitude': point.latitude,
  'longitude': point.longitude
  };
}

GeoPoint mapToGeoPoint(Map<String,double> map) {
  return new GeoPoint(map['latitude'], map['longitude']);
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

Future<GeoPoint> getCurrentLocation() {
  return Location().getLocation
      .then((here) => new GeoPoint(here['latitude'],here['longitude']));
}