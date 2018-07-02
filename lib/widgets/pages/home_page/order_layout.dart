import 'package:flutter/material.dart';

class OrderLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.fromLTRB(45.0, 0.0, 45.0, 10.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(const Radius.circular(15.0)),
        ),

        child: new Row(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 0.0),
                  child:new Icon(Icons.restaurant),
                ),
                new Padding(
                  padding: new EdgeInsets.fromLTRB(15.0, 0.0, 10.0, 0.0),
                  child:new Icon(Icons.more_vert),
                ),
                new Padding(
                  padding: new EdgeInsets.fromLTRB(15.0, 0.0, 10.0, 5.0),
                  child:new Icon(Icons.place),
                ),
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text("From: RC4 Utown",
                      style: new TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                // This is horizontal divider
                new Container(
                  margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  width: 220.0,
                  height: 2.0,
                  color: Colors.black12,
                ),
                new Row(
                  children: <Widget>[
                    new Text("To: Clementi Mall food court",
                        style: new TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ],
                )
              ],
            )
          ],
        )
    );
  }
}
