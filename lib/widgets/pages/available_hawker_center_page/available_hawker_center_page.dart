import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/widgets/pages/open_order_list_page/open_order_list_widget.dart';
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sambl/main.dart'; // to use the store created in main.dart.
import 'package:sambl/state/app_state.dart';
import 'package:sambl/action/write_action.dart';

class AvailableHawkerCenterPage extends StatefulWidget {
  @override
  _AvailableHawkerCenterPageState createState() => _AvailableHawkerCenterPageState();
}

class _AvailableHawkerCenterPageState extends State<AvailableHawkerCenterPage> {

  Future<Null> _refreshList() async {
    setState((){});
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new MyAppBar().build(context),
        backgroundColor: MyColors.mainBackground,
        body: new StoreConnector<AppState, List<HawkerCenter>>(
          converter: (store) => store.state.availableHawkerCenter,
          builder: (_, availableHawkerCenter) {
            print("currently app state's hawker center list is $availableHawkerCenter");
            print("currently app state's current hawker center is ${store.state.currentHawkerCenter}");
            return RefreshIndicator(
              onRefresh: _refreshList,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 5.0),
                itemCount: availableHawkerCenter.length,
                itemBuilder: (_, index) {
                  return _HawkerCenterTile(availableHawkerCenter[index]);
                }
              ),
            );
          },
        )
    );
  }

  @override
  void initState() {
    super.initState();
  }


}

class _HawkerCenterTile extends StatelessWidget {
  final HawkerCenter hawkerCenter;
  _HawkerCenterTile(this.hawkerCenter);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: MyColors.mainBackground,
          onTap: () {
            print("tapped the card of hawker center: ${this.hawkerCenter}");
            store.dispatch(new SelectHawkerCenterAction(this.hawkerCenter));
            print('''hawker center ${this.hawkerCenter.name} selected. 
            ''');
            Navigator.of(context).pop();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: new Row(
              children: <Widget>[
                // name of this particular hawker center


                new Expanded(
                  flex: 4,
                  child: new Center(
                    child: new Text("${this.hawkerCenter.name}",
                      style: const TextStyle(
                        fontSize: 20.0
                      ),
                    ),
                  ),
                ),

                // distance from user
                new Expanded(
                  flex: 1,
                  child: new Center(
                    child: new Text(" KM",
                      style: const TextStyle(
                        fontSize: 20.0
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}