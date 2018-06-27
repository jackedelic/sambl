import 'package:sambl/model/hawker_center.dart';

class WriteAction {
}

class WriteAvailableHawkerCenterAction extends WriteAction {
  List<HawkerCenter> toWrite;

  WriteAvailableHawkerCenterAction(List<HawkerCenter> list): this.toWrite = list;
}