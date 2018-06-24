import 'package:flutter/material.dart';
import 'package:sambl/widgets/shared/my_color.dart';

class MyAppBar extends StatelessWidget{

  Widget title = new Center(

    child: new Text('Sambl',
      style: new TextStyle(
        color: MyColors.mainRed,
        fontFamily: 'Indie Flower',
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  Color backgroundColor = Colors.white;
  Widget leading = new Icon(Icons.menu, color: MyColors.mainRed);
  double elevation = 0.0;

  MyAppBar({title,backgroundColor,leading, elevation}) {
    this.title = title ?? this.title;
    this.backgroundColor = backgroundColor ?? this.backgroundColor;
    this.leading = leading ?? this.leading;
    this.elevation = elevation ?? this.elevation;
  }

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      title: this.title,
      backgroundColor: this.backgroundColor,
      leading: this.leading,
      elevation: this.elevation,

      // Some space to align title 'Sambl' to the center
      actions: <Widget>[
          new Padding(padding: new EdgeInsets.all(30.0))
      ],
    );
  }

}

