import 'package:flutter/material.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:sambl/main.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/async_action/sign_out.dart';
import 'package:sambl/main.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sambl/widgets/shared/my_color.dart';
class OrdererListPage extends StatefulWidget {
  @override
  _OrdererListPageState createState() => _OrdererListPageState();
}

class _OrdererListPageState extends State<OrdererListPage> {
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: Scaffold(
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new DrawerHeader(child: new CircleAvatar(child: new Text("J.H"),)),
              new StoreConnector<AppState, Store<AppState>>(
                converter: (store) => store,
                builder: (_, store) {
                  return new ListTile(
                    title: new Center(
                      child: new Text("Sign out",
                        style: new TextStyle(
                          color: MyColors.mainRed,
                          fontSize: 20.0
                        ),
                      ),
                    ),
                    onTap: () {
                      store.dispatch(signOutAction);
                      Navigator.popAndPushNamed(context, '/SignInPage');
                    },

                  );
                }
              )
            ],
          ),
        ),
        appBar: new MyAppBar().build(context),
        backgroundColor: MyColors.mainBackground,
        body: new Column(
          children: <Widget>[
            // This is the label right below appbar. The text is "Delivering from [someplace]"
            new Container(
              margin: new EdgeInsets.only(top: 10.0, bottom: 5.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child:  new Text("Delivering from",
                      style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              color: Colors.white,
            ),


            // This is the list of users who subscribe to the deliverer's delivery.
//            new Expanded(
//                child: new ListView.builder(
//
//                    itemBuilder: (_, int n) {
//                      return new Container(
//                        margin: new EdgeInsets.symmetric(vertical: 5.0),
//                        color: Colors.white,
//                        child: new ExpansionTile(
//                          title: new Text("hei"),
//                          children: <Widget>[
//                            new Text("hi there i am jack")
//                          ],
//                        ),
//                      );
//                    }
//                )
//
//            )


          ],
        ),
      ),
    );
  }
}