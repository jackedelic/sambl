import 'package:flutter/material.dart';
import 'delivering_from_layout.dart';
import 'order_layout.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/pages/create_open_order_page/create_open_order_page.dart';
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
    _orderButtonColor = MyColors.mainRed; // Red
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
      backgroundColor: MyColors.mainBackground,
      body: new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage("assets/images/home_page_background.jpg"),
                    fit: BoxFit.cover,
                    )
              ),
              child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        new Padding(
                          padding: new EdgeInsets.only(bottom: 50.0),
                          child: new Text(
                            'SamBl',
                            style: new TextStyle(
                              fontSize: 60.0,
                              fontFamily: "Indie Flower", // Just a dummy fontfamily
                              color: MyColors.mainRed,
                            ),

                          ),
                        ),

                        // The center layout when orderbutton is selected.
                        _centerLayout,


                      // This row contains two radio buttons "order" and "deliver"

                       new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          // 'Order' button
                          new Container(
                            child: new FlatButton(
                              child: new Container(
                                child:  new Text("Order",
                                  style: new TextStyle(color: Colors.white),
                                ),
                              ),
                              onPressed: (){
                                setState(() {
                                  if (_orderButtonColor == MyColors.mainRed) return; // prevent the following lines from executing
                                  _orderButtonColor = MyColors.mainRed;
                                  _deliverButtonColor = new Color(0x38FFFFFF);
                                  _centerLayout = new OrderLayout();
                                  //_toggleFontColor();
                                });
                              },
                            ),
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.only(topLeft: new Radius.circular(10.0), bottomLeft: new Radius.circular(10.0)),
                              color: _orderButtonColor,
                            ),
                          ),

                          // Invisible divider between 'order' and 'Delievries' buttons

                          // 'Deliveries' button
                          new Container(
                            child: new FlatButton(
                              child: new Container(
                                child:  new Text("Deliveries",
                                  style: new TextStyle(color: Colors.white),
                                ),
                                color: Colors.transparent,
                              ),
                              onPressed: (){
                                setState(() {
                                  if (_deliverButtonColor == MyColors.mainRed) return; // prevent the following lines from executing
                                  _deliverButtonColor = MyColors.mainRed;
                                  _orderButtonColor = new Color(0x38FFFFFF);
                                  _centerLayout = new DeliveringFromLayout();
                                 // _toggleFontColor();

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
                                Navigator.pushNamed(context, "/CreateOpenOrderPage");
                              }
                            },
                            child: new Icon(Icons.arrow_forward_ios, color: Colors.white,),

                          ),
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
                            color: new Color(0x38FFFFFF),
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
