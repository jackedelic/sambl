import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/core.dart';
import 'package:map_view/map_view.dart';
import 'package:sambl/widgets/pages/available_hawker_center_page/available_hawker_center_page.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/utility/geo_point_utilities.dart';
import 'package:sambl/main.dart';
import 'package:redux/redux.dart';
import 'package:sambl/action/write_action.dart';

class OrderLayout extends StatefulWidget {
  @override
  _OrderLayoutState createState() => _OrderLayoutState();
}



class _OrderLayoutState extends State<OrderLayout> {
  GeoPoint geoPoint;
  MapView mapView;


  @override
  void initState() {
    super.initState();
    MapView.setApiKey(API_KEY);
    mapView = new MapView();
  }

  // assigns _geoPoint to the user's current location.
  void _setCurrentLocation() async {
    geoPoint = await getCurrentLocation();
    setState(() {

    });
  }

  // opens a page to show the map
  void _showMap() async {
    GeoPoint currentLocation = await getCurrentLocation();
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            initialCameraPosition: new CameraPosition(
                new Location(currentLocation.latitude, currentLocation.longitude), 14.0),
            title: "Your location"),
        toolbarActions: [new ToolbarAction("Close", 1), new ToolbarAction("Confirm", 2)]);

    mapView.onMapTapped.listen((location) {
      print("tapped location is $location");
      mapView.setMarkers([new Marker("1", "selected",location.latitude, location.longitude)]);

    });

    mapView.onMapReady.listen((Null _){
      if (geoPoint != null) {
        mapView.setMarkers([new Marker("1", "selected",geoPoint.latitude, geoPoint.longitude)]);
      }
    });
    
    mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        mapView.dismiss();
      } else if (id == 2) {
        if (mapView.markers.isNotEmpty){
          setState(() {
            geoPoint = new GeoPoint(mapView.markers[0].latitude, mapView.markers[0].longitude);
          });
          mapView.dismiss();
        }

      }
    });
  }

  Future<Null> _displayDialog(BuildContext context) {
    return showDialog<Null>(
        context: context,
        builder: (_) {
          return new AlertDialog(
            title: const Text("Missing something..."),
            content: const Text('''Did you forget to select the hawker 
center you want to order from? ''',
              style: const TextStyle(
                  fontSize: 16.0
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: new Text("Yes I did")
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new Container(
        padding: new EdgeInsets.symmetric(vertical: 15.0),
        margin: new EdgeInsets.only(bottom: 20.0),
        width:  screenWidth,
        decoration: new BoxDecoration(
          color: new Color(0x38FFFFFF),
        ),

        child: new Row(
          children: <Widget>[
            // This is the left 'padding' that comes before the 'location'
            new Expanded(
              flex: 1,
              child: new Container(width: 1.0, height: 0.0,),
            ),


            new Flexible(
              flex: 4,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  // This is the 'From ... ' row.
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      StoreConnector<AppState, Store<AppState>>( //
                        converter: (store) => store,

                        builder: (_, store) {
                          return new Expanded(
                            child: new GestureDetector(
                              onTap:() {
                                print("You tapped 'From: ... ' box");
                                print("in order layout, openOrderList is ${store.state.openOrderList}");
                                store.dispatch(new SetLocationAction(toWrite: geoPoint));
                                Navigator.push(context,
                                    new MaterialPageRoute(builder: (context) => new AvailableHawkerCenterPage())
                                );
                              },
                              child: new Text("${store.state.currentHawkerCenter.isPresent ? 'Ordering from: ${store.state.currentHawkerCenter.value.name}' : "Press to select a hawker center"}",
                                style: new TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          );
                        }

                      )
                    ],
                  ),

                  // This is horizontal divider
                  new Container(
                    margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    width: 256.0,
                    height: 1.0,
                    color: Colors.white,
                  ),

                  // This is right below the 'from'
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        flex: 5,
                        child: new InkWell(
                          onTap:(){
                            _showMap();
                          },
                          child: new Text("${geoPoint == null ? 'Tap to select your location' : '${geoPoint.latitude.toStringAsFixed(4)}E    ${geoPoint.longitude.toStringAsFixed(4)}N'}",
                              style: new TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                color: Colors.white
                              )
                          ),
                        ),
                      ),

                      // vertical divider -> Tap to select your location | Use my location
                      new Container(
                        height: 20.0,
                        width: 1.0,
                        color: Colors.white,
                      ),

                      // use my location
                      new Expanded(
                        flex: 2,
                        child: new InkWell(
                          onTap: () async {
                            print("you tapped 'use my location'");
                            store.dispatch(new SetLocationAction(toWrite: await getCurrentLocation()));
                            _setCurrentLocation();
                          },
                          child: new Row(
                            children: <Widget>[
                              new Icon(Icons.place, color: Colors.white,),
                              new Expanded(
                                child: new Text("Use my location",
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )


                    ],
                  )
                ],
              ),
            ),

            // This is the arrow button
            new StoreConnector<AppState, Optional<HawkerCenter>>(
              converter: (store) => store.state.currentHawkerCenter,
              builder: (_, currentHawkerCenter) {

                return new Expanded(
                  flex: 1,
                  child: new IconButton(
                      icon: new Icon(Icons.chevron_right, color: Colors.white,),
                      onPressed: () {
                        if (currentHawkerCenter.isPresent) {
                          Navigator.of(context).pushNamed("/OpenOrderListPage");
                        } else {
                          _displayDialog(context);
                        }

                      }),

                );

              },

            )


          ],
        )
    );
  }
}
