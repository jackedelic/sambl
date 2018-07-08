import 'package:flutter/material.dart';

class DeliveringFromLayout extends StatelessWidget {
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
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Text("Delivering from: ",
                        style: new TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                  // This is horizontal divider


                ],
              ),
            ),

            // This is the arrow button
            new Flexible(
              flex: 1,
              child: new IconButton(
                icon: new Icon(Icons.chevron_right),
                onPressed: () {
                  Navigator.of(context).pushNamed("/CreateOpenOrderPage");
                }),
            )


          ],
        )
    );
  }
}
