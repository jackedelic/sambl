import 'package:cloud_firestore/cloud_firestore.dart';

class HawkerCenterStall {
  String name;

  bool equals(HawkerCenterStall other) => (this.name == other.name);

  HawkerCenterStall(String stallName): this.name = stallName;

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
  
  @override
  String toString() {
      // TODO: implement toString
      return this.name;
  }
  
}