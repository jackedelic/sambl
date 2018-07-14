import 'dart:convert';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

import 'package:sambl/utility/geo_point_utilities.dart';

class HawkerCenterStall {
  String name;


  bool equals(HawkerCenterStall other) => (this.name == other.name);

  HawkerCenterStall({this.name});

  Map<String,dynamic> toJson() => {
    'name': this.name
  };

  @override
  String toString() {
      // TODO: implement toString
      return this.name;
  }
  
}

class HawkerCenter {
  final GeoPoint location;
  final String name;
  final String uid;
  final List<HawkerCenterStall> stallList;
  
  HawkerCenter(GeoPoint location, String hawkerCenterName, 
    List<HawkerCenterStall> stallList, String uid): this.location = location,
    this.name = hawkerCenterName, this.stallList = stallList, this.uid = uid;
  
  Map<String,dynamic> toJson() => {
    'name': this.name,
    'location': geoPointToMap(this.location),
    'stalls': this.stallList.map<Map<String,dynamic>>((stall) => stall.toJson()).toList()
  };

  Future<double> distance() async {
    return Location().getLocation
      .then(mapToGeoPoint)
      .then((here) => getDistance(here,this.location));
  }
  
  @override
  String toString() {
    return json.encode(this.toJson());
  }
  
}