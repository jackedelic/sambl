import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


/// This class constructs a stateless widget that displays a number, usually a quantity or amount
/// of some countable objects, tangible or not tangible such as time, shopping items, and currency.
/// The widget typically comprises three rows (max) with the middle row displaying the number
/// representing the quantity, the other two representing one or two words.
/// e.g:
///   arriving in
///       5
///     mins
///
/// The default font size of the number is ~2x larger than the words to make it conspicuous.
///
/// Note that the constructed object is an Expanded widget. Place it in a Row or Col.
class QuantityDisplay extends StatefulWidget {
  /// The word(s) in the first row
  QuantityDisplayElement _head;
  /// The quantity, usually an int or double/float
  QuantityDisplayElement _quantity;
  /// Thw word(s) in the last(third) row
  QuantityDisplayElement _tail;

  QuantityDisplay({
    head,
    quantity,
    tail,
  }) {
    _head = head;
    _quantity = quantity;
    _tail = tail;
  }


  @override
  QuantityDisplayState createState() => new QuantityDisplayState();

}

class QuantityDisplayState extends State<QuantityDisplay> {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Column(
        children: <Widget>[
          new Text("${widget._head.content}",
            style: new TextStyle(
                fontSize: widget._head.fontSize ?? 16.0
            ),
          ),
          new Text("${widget._quantity.content}",
            style: new TextStyle(
                fontSize: widget._quantity.fontSize ?? 30.0
            ),
          ),

          new Text("${widget._tail.content}",
            style: new TextStyle(
                fontSize: widget._tail.fontSize ?? 16.0
            ),
          )
        ],
      ),
    );
  }
}

/// This class contructs an element representing the words/numbers to be displayed
/// in a row of a QuantityDisplay widget.
class QuantityDisplayElement {
  dynamic content;
  double fontSize;
  QuantityDisplayElement({this.content, this.fontSize});
}