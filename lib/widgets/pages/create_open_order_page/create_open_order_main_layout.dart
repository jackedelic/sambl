import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/ensure_visible_when_focus.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map_view/map_view.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/main.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sambl/widgets/pages/create_open_order_page/create_open_order_page.dart';
import 'package:sambl/utility/geo_point_utilities.dart';
import 'package:sambl/widgets/shared/my_color.dart';

import 'package:sambl/action/write_action.dart';
/*
* TODO: automatically initialize info's geopoint when navigated to this page.
* */

/// This is the layout that first appear when the user pressed 'Deliver' button on the
/// home page.
class CreateOpenOrderMainLayout extends StatefulWidget {

  CreateOpenOrderMainLayout();

  @override
  _CreateOpenOrderMainLayoutState createState() =>
      _CreateOpenOrderMainLayoutState();
}

class _CreateOpenOrderMainLayoutState extends State<CreateOpenOrderMainLayout> {

  TextEditingController pickUpPtController = new TextEditingController();
  MapView mapView;
  var staticMapProvider = new StaticMapProvider(API_KEY);
  Uri staticMapUri;
  GeoPoint geoPoint;

  @override
  void initState() {
    super.initState();
    MapView.setApiKey(API_KEY);
    mapView = new MapView();
    staticMapUri = staticMapProvider.getStaticUri(new Location(1.35,103.8), 6);
    _getCurrentLocation();
    print(staticMapUri.toString());
  }

  // set geoPoint then set staticMapUri which requires geoPoint.
  Future<Uri> _getCurrentLocation() async {
    geoPoint = await getCurrentLocation();
    setState(() {
      staticMapUri = _getStaticUriWithMarkers(geoPoint, [new Marker("1","my location", geoPoint.latitude, geoPoint.longitude)]);
    });
    print('test');
    print(staticMapUri.toString());
    return staticMapUri;
  }

  Uri _getStaticUriWithMarkers(GeoPoint geoPoint, List<Marker> markers) {
    return staticMapProvider.getStaticUriWithMarkers(markers ,center: geoPoint != null ? new Location(geoPoint.latitude, geoPoint.longitude) : Locations.centerOfUSA,
        width: 900, height: 400, maptype: StaticMapViewType.roadmap);
  }

  // opens a page to show the map
  void _showMap(Function callback) async {
    GeoPoint currentLocation = await getCurrentLocation();
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            initialCameraPosition: new CameraPosition(
                new Location(currentLocation.latitude, currentLocation.longitude), 14.0),
            title: "Your location"),
        toolbarActions: [new ToolbarAction("Close", 1), new ToolbarAction("Confirm", 2)]);

    mapView.onMapReady.listen((Null _){
      if (geoPoint != null) {
        mapView.setMarkers([new Marker("1", "selected",geoPoint.latitude, geoPoint.longitude)]);
      }
    });

    mapView.onMapTapped.listen((location) {
      print("tapped location is $location");
      mapView.setMarkers([new Marker("1", "selected",location.latitude, location.longitude)]);
      print(mapView.markers.length);
    });

    mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        mapView.dismiss();
      } else if (id == 2) {
        print("len is: " + mapView.markers.length.toString());
        if (mapView.markers.isNotEmpty){
          callback(new GeoPoint(mapView.markers[0].latitude, mapView.markers[0].longitude));
          staticMapUri = _getStaticUriWithMarkers(geoPoint, mapView.markers);
          geoPoint = new GeoPoint(mapView.markers[0].latitude, mapView.markers[0].longitude);
          setState(() {

          });
          mapView.dismiss();
        }

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        // This is the static map.
        new Container(
          margin: new EdgeInsets.symmetric(horizontal: 0.0),
          width: MediaQuery.of(context).size.width - 40.0,
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
          child: Stack(
            children: <Widget>[
              new Center(
                child: ClipRRect(
                  child: new Image.network(staticMapUri.toString()),
                  borderRadius: new BorderRadius.only(topRight: new Radius.circular(20.0), topLeft: new Radius.circular(20.0)),
                ),
              ),

              // this is the inkwell that shows interactive map when tapped.
              ScopedModelDescendant<Info>(
                builder: (_, child, info) {
                  return new Positioned(
                    bottom: 0.0,
                    height: 30.0,
                    width: MediaQuery.of(context).size.width - 40.0,
                    child: Container(
                      color: new Color(0x78000000),
                      child: Center(
                        child: new StoreConnector<AppState,Function>(
                          converter: (store) => (GeoPoint location) => store.dispatch(new SetLocationAction(toWrite: location)),
                          builder: (context,callback) => new InkWell(
                            onTap: (){
                              _showMap(callback);
                              info.editInfo(pickupPoint: geoPoint);
                            },
                            child: new Text("Tap to select pick up point",
                              style: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ) 
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        new StoreConnector<AppState,Store<AppState>>(
          converter: (store) => store,
          builder: (context,store){
            return new Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: new FutureBuilder<GeoPoint>(
                future: store.state.currentLocation,
                initialData: new GeoPoint(0.0, 0.0),
                builder: (context,snapshot) { 
                  print(snapshot.data.latitude);
                  print(snapshot.data.longitude);
                  return new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("latitude: " + snapshot.data.latitude.toStringAsFixed(4),
                        style: new TextStyle(color: Colors.black54),
                      ),
                      new Container(width: 1.5, height: 20.0,color: Colors.grey,margin: const EdgeInsets.symmetric(horizontal: 7.0),), // vertical divider
                      new Text("longitude: " + snapshot.data.longitude.toStringAsFixed(4),
                        style: new TextStyle(color: Colors.black54),
                      ),
                    ],
                  );
                }
              )
            );
          } ,
        ), 
        //latitude and longitude

        // Just some space in btwn the two rows.
        new Padding(padding: new EdgeInsets.all(5.0)),

        // Second row: 'closing time' and 'eta'

        new Container(
          margin: new EdgeInsets.symmetric(horizontal: 20.0),
          child: new Row(
            children: <Widget>[
            // 'Closing time' element
              new Expanded(
                  flex: 3,
                  child: new Container(
                    alignment: Alignment.center,
                    padding: new EdgeInsets.all(10.0 ),
                    decoration: new BoxDecoration(
                        border: new Border.all(
                            color: MyColors.borderGrey, width: 1.8),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(15.0))),

                    // This is the closing time button that shows time picker onpressed.
                    child: new ScopedModelDescendant<Info>(
                      builder: (context, child, info){
                          return new GestureDetector(
                            onTap: () async {
                              print("tapped order closing time");
                              _showTimePicker(Detail.CLOSINGTIME, context, info);
                            },
                            child: new Text(
                              info.closingTime != null ?
                              ("Closing at ${info.closingTime?.hour ?? DateTime.now().hour}:${info.closingTime.minute  ?? DateTime.now().minute}") :
                              "Order Closing time",
                              style: new TextStyle(
                                fontSize: 16.0
                              ),
                            ),
                          );
                      }


                    ),

                  ),
              ),

              // Just some space in btwn 'closing time' and 'ETA' elements
              new Padding(padding: new EdgeInsets.all(5.0)),

              // 'ETA' element
              new Expanded(
                  flex: 2,
                  child: new Container(
                      padding: new EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(
                              color: MyColors.borderGrey, width: 1.8),
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(15.0))),

                      // This is the eta button that shows time picker on pressed.
                      child: new ScopedModelDescendant<Info>(
                        builder: (context, child, info){
                          return new GestureDetector(
                              onTap: () async {
                                print("tapped order ETA");
                                _showTimePicker(Detail.ETA, context, info);
                              },
                              child: new Text(
                                      info.eta != null ?
                                      ("ETA: ${info.eta?.hour ?? DateTime.now().hour}:${info.eta.minute  ?? DateTime.now().minute}") :
                                      "ETA",
                                    style: new TextStyle(
                                      fontSize: 16.0
                                    ),
                                  )
                          );
                        },
                      ),

                    )
                  )
                ],
              ),
            ),


        // Just some space btwn the two rows
        new Padding(
          padding: new EdgeInsets.symmetric(vertical: 10.0),
        ),

        // The list of nearby places

      ],
    );
  }

  void _showTimePicker(Detail detail, context, Info info) async {
    int initialIndex = DateTime.now().hour * 4 + (DateTime.now().minute / 15).floor();
    FixedExtentScrollController controller = new FixedExtentScrollController(initialItem: initialIndex);

    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return new Container(
                height: 250.0,
                child: new Row(
                    children: <Widget>[
                      //select hour
                      new Flexible(
                        flex: 1,
                        child: new CupertinoPicker(
                          scrollController: controller,
                          itemExtent: 40.0,
                          onSelectedItemChanged: (index){
                            int hour = (index / 4).floor();
                            int min = (index % 4) * 15;
                            print("selected index is $index");
                            switch (detail) {
                              case Detail.CLOSINGTIME:
                                print("time picker for closing time");
                                info.editInfo(closingTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, min));
                                break;
                              case Detail.ETA:
                                print("time picker for eta");
                                info.editInfo(eta: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, min));
                                break;
                            }
                          },
                          children: Iterable.generate(96, (index){
                            int hour = (index / 4).floor();
                            int min = (index % 4) * 15;
                            return new Container(
                                child: new Text("$hour : ${min == 0 ? '00' : min}",
                                  style: new TextStyle(
                                    fontSize: 30.0,
                                  ),

                                )

                            );
                          }).toList(),
                        ),
                      ),

                    ]
                ),
              );

        }
    );
  }
}

/// label for the time picker
enum Detail {
  CLOSINGTIME, ETA
}