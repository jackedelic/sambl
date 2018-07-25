import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/async_action/sign_out.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/widgets/shared/my_color.dart';

class MyDrawer extends StatefulWidget {


  MyDrawer();

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SignOutCallback>(
      converter: (store) => (action) => store.dispatch(action),
      builder: (_, callback){
        return new Drawer(
          child: new Column(
            children: <Widget>[
              new DrawerHeader(
                  child: StoreConnector<AppState, String>(
                    converter: (store) => store.state.currentUser.,
                    child: new CircleAvatar(
                      radius: 60.0,
                      backgroundImage: new NetworkImage("https://i.imgur.com/BoN9kdC.png"),
                    ),
                  )),
              new Expanded(
                child: new ListView(
                  children: <Widget>[
                    new ListTile(
                      leading: new Text("Balance: 143,123,990"),
                    ),
                    Center(child: new Container(height: 1.0, width: 270.0, color: Colors.grey,)),
                    new ListTile(
                      leading: new Text("Top up "),
                    ),
                    Center(child: new Container(height: 1.0, width: 270.0, color: Colors.grey,)),
                    new ListTile(
                      leading: new Text("Donate "),
                    ),
                    Center(child: new Container(height: 1.0, width: 270.0, color: Colors.grey,)),
                    new ListTile(
                      leading: new Text("Detonate "),
                    ),
                    Center(child: new Container(height: 1.0, width: 270.0, color: Colors.grey,)),

                  ],
                )
              ),
              new ListTile(
                title: new Center(
                  child: new Text(
                    "Sign out",
                    style: new TextStyle(color: MyColors.mainRed, fontSize: 20.0),
                  ),
                ),
                onTap: () {
                  callback(signOutAction);
                  Navigator.popAndPushNamed(context, '/');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

typedef SignOutCallback = Function(ThunkAction<AppState> action);