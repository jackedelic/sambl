import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/widgets/pages/open_order_list_page/open_order_list_widget.dart';
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/async_action/get_delivery_list.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sambl/main.dart'; // to use the store created in main.dart.
import 'package:sambl/state/app_state.dart';

class AvailableHawkerCenterPage extends StatefulWidget {
  @override
  _AvailableHawkerCenterPageState createState() => _AvailableHawkerCenterPageState();
}

class _AvailableHawkerCenterPageState extends State<AvailableHawkerCenterPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new MyAppBar().build(context),
        backgroundColor: MyColors.mainBackground,
        body: new Column(
          children: <Widget>[

          ],
        )
    );
  }

  @override
  void initState() {
    super.initState();
    print("currently app state's hawker center list is ${store.state.availableHawkerCenter}");
  }
}

class _HawkerCenterTile extends StatelessWidget {
  final HawkerCenter hawkerCenter;
  _HawkerCenterTile(this.hawkerCenter);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: new Row(
        children: <Widget>[
          // name of this particular hawker center
          new Expanded(
            flex: 4,
            child: new Center(
              child: new Text("${this.hawkerCenter.name}"

              ),
            ),
          ),

          // distance from user 
          new Expanded(
            flex: 1,
            child: new Center(
              child: new Text(" KM"

              ),
            ),
          )
        ],
      ),
    );
  }
}