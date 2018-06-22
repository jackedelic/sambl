import 'package:flutter/material.dart';
import 'delivering_from_layout.dart';
import 'order_layout.dart';


/*
* This is the first page a signed in user sees when opening the app.
* It has two big buttons, 1) letting user to choose whether to deliver food for others
* or 2) looking for available delivery services.
*/


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  Color _orderButtonColor;
  Color _deliverButtonColor;
  Widget _centerLayout;
  Color _fontColor1; // font color for the order button. When button turns red, the text turns white.
  Color _fontColor2; // font color for the deliver button. When button turns red, the text turns white.
  @override
  void initState() {
    super.initState();
    _orderButtonColor = new Color(0xFFDF1B01); // Red
    _deliverButtonColor = Colors.white;

    _centerLayout = new OrderLayout();
    _fontColor1 = Colors.white;
    _fontColor2 = Colors.black;
  }

  // toggle the color of the two buttons (order/deliver) at the same time from
  // black to white (vice versa).
  void _toggleFontColor() {
    if (_fontColor1 == Colors.black) {
      _fontColor1 = Colors.white;
      _fontColor2 = Colors.black;
    } else {
      _fontColor2 = Colors.white;
      _fontColor1 = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: new Color(0xFFEBEBEB),
      body: new Center(
              child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                          padding: new EdgeInsets.only(bottom: 70.0),
                          child: new Text(
                            'Hawker Jio',
                            style: new TextStyle(
                              fontSize: 50.0,
                              fontFamily: "Indie Flower", // Just a dummy fontfamily
                              color: new Color(0xFFDF1B01),
                            ),

                          ),
                        ),

                        // The center layout when orderbutton is selected.
                        _centerLayout,


                      // This row contains two radio buttons "order" and "deliver"

                       new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          new Container(

                            child: new FlatButton(
                              child: new Container(
                                child:  new Text("Order",
                                  style: new TextStyle(color: _fontColor1),
                                ),
                              ),
                              onPressed: (){
                                setState(() {
                                  if (_orderButtonColor == new Color(0xFFDF1B01)) return; // prevent the following lines from executing
                                  _orderButtonColor = new Color(0xFFDF1B01);
                                  _deliverButtonColor = Colors.white;
                                  _centerLayout = new OrderLayout();
                                  _toggleFontColor();
                                });
                              },
                            ),
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.only(topLeft: new Radius.circular(10.0), bottomLeft: new Radius.circular(10.0)),
                              color: _orderButtonColor,
                            ),
                          ),
                          //A vertical divider in between the two buttons.
                          new Container(
                            width: 2.0,
                            height: 25.0,
                            color: Colors.black12 ,
                          ),

                          new Container(
                            child: new FlatButton(
                              child: new Container(
                                child:  new Text("Deliveries",
                                  style: new TextStyle(color: _fontColor2),
                                ),
                                color: Colors.transparent,
                              ),
                              onPressed: (){
                                setState(() {
                                  if (_deliverButtonColor == new Color(0xFFDF1B01)) return; // prevent the following lines from executing
                                  _deliverButtonColor = new Color(0xFFDF1B01);
                                  _orderButtonColor = Colors.white;
                                  _centerLayout = new DeliveringFromLayout();
                                  _toggleFontColor();

                                });
                              },

                            ),
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.only(topRight: new Radius.circular(10.0), bottomRight: new Radius.circular(10.0)),
                              color: _deliverButtonColor,
                            ),
                          ),

                        ],
                      ),




                       // Button that navigates to another route
                        new Container(
                          margin: new EdgeInsets.only(top: 150.0  ),
                          child: new FlatButton(
                            onPressed: (){
                              if (_orderButtonColor == new Color(0xFFDF1B01)) {
                                Navigator.pushNamed(context, "/OpenOrderListPage");
                              } else if (_deliverButtonColor == new Color(0xFFDF1B01)) {

                              }
                            },
                            child: new Icon(Icons.arrow_forward_ios, color: new Color(0xFFDF1B01),),

                          ),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
                            color: Colors.white,
                          ),


                        )

                      ],
                    )
            ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new DrawerHeader(
                child: new CircleAvatar(
                  child: new Text('J'),
                  backgroundColor: Color.fromRGBO(247, 64, 106, 1.0),
                ),
              
            ),
            new ListTile(
              title: new Text("Profile"),
              
            ), 
            new ListTile(
              title: new Text("Settings"),
              
            ),
            new ListTile(
              title: new Text("Account"),
            )
          ],
        ),
      ),
    );
  }
}
