import 'package:flutter/material.dart';

class DeliveringFromLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.fromLTRB(45.0, 0.0, 45.0, 56.0),
        padding: new EdgeInsets.only(top: 6.0, bottom: 6.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(const Radius.circular(15.0)),
        ),

        child: new Row(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.fromLTRB(15.0, 0.0, 10.0, 0.0),
                  child:new Icon(Icons.restaurant),
                ),
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text("Delivering from: Clementi Mall food court",
                      style: new TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                // This is horizontal divider


              ],
            )
          ],
        )
    );
  }
}
