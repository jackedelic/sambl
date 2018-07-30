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

import 'package:sambl/utility/sort_hawker_center.dart';

class AvailableHawkerCenterPage extends StatefulWidget {
  @override
  _AvailableHawkerCenterPageState createState() => _AvailableHawkerCenterPageState();
}

class _AvailableHawkerCenterPageState extends State<AvailableHawkerCenterPage> {
  bool timeOut = false; // timeOut becomes true after an arbitrary amount of duration fetching the list.
  
  Future<Null> _refreshList() async {
    setState((){});
    timeOut = false;
    return null;
  }

  Widget _displayCircularProgressIndicator() {
    print("circular progressing in available_hawker_center_page");
    if (!timeOut) {
      Future.delayed(const Duration(seconds: 10), () {
        timeOut = true;
        setState(() {

        });
      });
    }
    if (timeOut) {
      return Expanded(
        child: Center(
          child: new Text(
            '''There probably is no hawker center available nearby. 
You may also stay on this page and wait. ''',
            style: new TextStyle(
              fontSize: 18.0,
              color: MyColors.mainRed,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Expanded(child: Center(child: new CircularProgressIndicator()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new MyAppBar().build(context),
      backgroundColor: MyColors.mainBackground,
      body: new StoreConnector<AppState, Future<List<HawkerCenter>>>(
        converter: (store) => sortHawkerCenter(store.state.availableHawkerCenter,store.state.currentLocation),
        builder: (_, availableHawkerCenter) {
          return new FutureBuilder(
            future: availableHawkerCenter,
            initialData: new List<HawkerCenter>(),
            builder: (context,snapshot) {
              if (snapshot.data.length > 0) {
                return RefreshIndicator(
                  onRefresh: _refreshList,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 5.0),
                    itemCount: snapshot.data.length,
                      itemBuilder:  (_, index) {
                        return _HawkerCenterTile(snapshot.data[index]);
                      }
                    )
                  );
              } else {
                return _displayCircularProgressIndicator();
              }
            }
          );
        } 
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
  _HawkerCenterTile(this.hawkerCenter) ;


  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        color: Colors.white,
        child: StoreConnector<AppState, Store<AppState>>(
          converter: (store) => store,
          builder: (_, store) {
            return InkWell(
              splashColor: MyColors.mainBackground,
              onTap: () {
                print("tapped the card of hawker center: ${this.hawkerCenter}");
                // subtle diff between this store and that store
                store.dispatch(new SelectHawkerCenterAction(this.hawkerCenter));
                print('''current hawker center is ${store.state.currentHawkerCenter}. 
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
                      child: new Container(
                        margin: const EdgeInsets.only(right: 20.0),
                        child: FutureBuilder<double>(
                          future: this.hawkerCenter.distance(store.state.currentLocation).then((distance) => distance / 1000.0),
                          builder: (_, snapshot){
                            return new Text("${snapshot.data != null ? '${snapshot.data.toStringAsFixed(2)}KM' : 'loading distance'}",
                              style: const TextStyle(
                                  fontSize: 20.0
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}