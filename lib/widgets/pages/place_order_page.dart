import 'package:flutter/material.dart';
class PlaceOrderPage extends StatefulWidget {
  @override
  _PlaceOrderPageState createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Container(
            padding: new EdgeInsets.only(left: 75.0),
            child: new Text('HawkerJio',
            style: new TextStyle(
                color: new Color(0xFFDF1B01),
                fontFamily: 'Indie Flower',
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        backgroundColor: Colors.white,
        leading: new Icon(Icons.menu, color: new Color(0xFFDF1B01),),
        elevation: 0.0,
      ),
      backgroundColor: new Color(0xFFEBEBEB),
      body: new Column(
        children: <Widget>[
          // "Delivering From" title/banner.
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

          // AddStallCard cards
          new Expanded(
              child: new ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int n) {
                    return new AddStallCard("Wakanda stall");
                  }
              )
          ),

        ],
      ),
    );
  }
}

// This class constructs a card that represents a stall. When a user click 'Add Stalls' button,
// a new AddStallCard object will be created. It contains info such as the dish the user wants to
// order.
class AddStallCard extends StatefulWidget {
  final String stallName;

  AddStallCard(this.stallName);

  @override
  _AddStallCardState createState() => _AddStallCardState();
}

class _AddStallCardState extends State<AddStallCard> {

  List<String> dishes = new List<String>(); // temporarily a string

  @override
  void initState() {
    dishes.add("Chicken Masala Tika"); // dummy values for the time being (early development phase).
    dishes.add("High calorie food");
    dishes.add("duck rice where the meat is injected with chemicals");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // bottom padding for the card
      padding: new EdgeInsets.only(bottom: 15.0),
      child: new Column(
        children: <Widget>[

          // The title of the card, which is the stall name
          new Container(
            color: new Color(0xFF9A9A9A),
            padding: new EdgeInsets.all(15.0),
            child: new Row(
              children: <Widget>[
                new Text(widget.stallName,
                  // The grey part of the card
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 17.0
                  ),

                ),


              ],
            ),

          ),
          // The white part of the card.
          new Container(
            color: Colors.white,
            padding: new EdgeInsets.all(10.0),
            // dishes for this particular stall. Remember each card represents one stall.
            child: new Column(
              children: <Widget>[
                // The expanded wraps all dishes in this card. Remember each card represents one stall.


                // This is the +Add stalls button
                new Row(

                  children: <Widget>[
                    new FlatButton(
                      padding: new EdgeInsets.all(10.0),
                      onPressed: (){},
                      child: new Text("+ Add stalls"),
                    ),
                  ],
                ),

//                new Expanded(
//                  child: new ListView(
//                    children: <Widget>[
//                      new Text("jj"),
//                    ],
//                  ),
////                    child: new ListView.builder(
////                        itemCount: 10,
////                        itemBuilder: (BuildContext context, int index) {
//////                          return new ListView(
//////                            children: <Widget>[
//////                              new Text(dishes[index]),
//////                            ],
//////
//////                          );
////                        }
////                    ),
//                ),
              ],
            ),
          ),



        ],
      ),
    );
  }
}

