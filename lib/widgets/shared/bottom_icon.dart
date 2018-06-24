import 'package:flutter/material.dart';
import 'package:sambl/widgets/shared/my_color.dart';

/// This class constructs an elongated icon usually placed at the bottom of a page.
/// It is used to indicate the page number. E.g If a form consists of a few pages,
/// we can place this icon on all the pages belonging to the form. The icon indicates how many pages
/// you have completed, which page you're at and how many pages more to be completed.
/// The icon consists of a few (four at the moment) circular icons connected by lines (or bridge).
///
class BottomIcon extends StatelessWidget {
  /// This is the current page number. The 'circular' icon corresponding to this page number will
  /// turn red. All preceding 'circular' icons will be 'done' icons, indicating completion of those
  /// pages.
  int pageNum;

  BottomIcon({this.pageNum}){
    assert(pageNum <= 4);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.symmetric(vertical: 0.0),
      child: new Row(
        children: <Widget>[
          //1st circle
          new Container(
            padding: pageNum <= 1 ? new EdgeInsets.only(top: 12.5, bottom: 6.5, left: 10.0, right: 10.0) : new EdgeInsets.all(5.0),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(16.0),
              color: pageNum == 1 ? MyColors.mainRed : Colors.grey,
            ),
            child: pageNum == 1 ? new Text("1", style: new TextStyle(height: 0.5, color: Colors.white),)
            : new Icon(Icons.done, size: 17.0, color: Colors.white,),
          ),

          // bridge
          new Container(
            color: Colors.grey,
            height: 2.0,
            width: 20.0,
          ),

          //2nd circle
          new Container(
              padding: pageNum <= 2 ? new EdgeInsets.only(top: 12.5, bottom: 6.5, left: 10.0, right: 10.0) : new EdgeInsets.all(5.0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(16.0),
                color: pageNum == 2 ? MyColors.mainRed : Colors.grey,
              ),
              child: pageNum <= 2 ? new Text("2", style: new TextStyle(height: 0.5,  color: Colors.white),)
                  :  new Icon(Icons.done, size: 17.0, color: Colors.white,),
          ),

          // bridge
          new Container(
            color: Colors.grey,
            height: 2.0,
            width: 20.0,
          ),

          //3rd circle
          new Container(
              padding: pageNum <= 3 ? new EdgeInsets.only(top: 12.5, bottom: 6.5, left: 10.0, right: 10.0) : new EdgeInsets.all(5.0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(16.0),
                color:pageNum == 3 ? MyColors.mainRed : Colors.grey,
              ),
              child: pageNum <= 3 ? new Text("3", style: new TextStyle(height: 0.5,  color: Colors.white ),)
                  :  new Icon(Icons.done, size: 17.0, color: Colors.white,),
          ),

          // bridge
          new Container(
            color: Colors.grey,
            height: 2.0,
            width: 20.0,
          ),

          //4th circle
          new Container(
              padding: pageNum <= 4 ? new EdgeInsets.only(top: 12.5, bottom: 6.5, left: 10.0, right: 10.0) : new EdgeInsets.all(5.0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(16.0),
                color: pageNum == 4 ? MyColors.mainRed : Colors.grey,
              ),
              child: pageNum <= 4 ? new Text("4", style: new TextStyle(height: 0.5,  color: Colors.white),)
                  :  new Icon(Icons.done, size: 17.0, color: Colors.white,),
          ),

        ],
      ),
    );
  }
}
