import 'package:cloud_firestore/cloud_firestore.dart';

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
  GeoPoint location;
  String name;
  List<HawkerCenterStall> stallList;
  
  HawkerCenter(GeoPoint location, String hawkerCenterName, 
    List<HawkerCenterStall> stallList): this.location = location,
    this.name = hawkerCenterName, this.stallList = stallList;
  
  Map<String,dynamic> toJson() => {
    'name': this.name,
    'location': geoPointToMap(this.location),
    'stalls': this.stallList.map<Map<String,dynamic>>((stall) => stall.toJson()).toList()
  };
  
  @override
  String toString() {
      // TODO: implement toString
      return this.name;
  }
  
}