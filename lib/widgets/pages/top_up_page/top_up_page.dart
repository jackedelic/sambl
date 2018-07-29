import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:sambl/state/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

final flutterWebviewPlugin = new FlutterWebviewPlugin();

const topUpUrl1000 = "https://sambl-1093.firebaseapp.com/?amount=1000&uid=";
const topUpUrl2000 = "https://sambl-1093.firebaseapp.com/?amount=2000&uid=";
const topUpUrl5000 = "https://sambl-1093.firebaseapp.com/?amount=5000&uid=";
const topUpUrl10000 = "https://sambl-1093.firebaseapp.com/?amount=10000&uid=";

enum Amount {
  // $5, $20, $50, $100
  TIER1, TIER2, TIER3, TIER4
}

class TopUpPage extends StatefulWidget {
  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  TopUpPageModel topUpPageModel;
  @override
  void initState() {
    super.initState();
    topUpPageModel = new TopUpPageModel(Amount.TIER1);
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin.close();
    flutterWebviewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: new Text("Top Up",
          style: new TextStyle(
            color: MyColors.mainRed,
            fontSize: 20.0
          ),
        ),
      ).build(context),
      body: ScopedModel<TopUpPageModel>(
        model: topUpPageModel,
        child: new Column(
          children: <Widget>[
            // some padding on top
            new Padding(padding: const EdgeInsets.symmetric(vertical: 5.0)),
            // four boxes
            new Expanded(
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      // vertical space to the left of the button
                      new Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      ),

                      new TopUpRadioButton(Amount.TIER1, "5.99"),

                      // vertical space
                      new Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      ),

                      new TopUpRadioButton(Amount.TIER2, "11.99"),

                      // vertical space to the right of the button
                      new Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      ),

                    ],
                  ),

                  // Horizontal spave betwn the tow rows
                  new Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),

                  new Row(
                    children: <Widget>[
                      // vertical space to the left of the button
                      new Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      ),

                      new TopUpRadioButton(Amount.TIER3, "29.99"),

                      // vertical space
                      new Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      ),

                      new TopUpRadioButton(Amount.TIER4, "59.99"),

                      // vertical space to the right of the button
                      new Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      ),

                    ],
                  )
                ],
              )
            ),

            // top up button
            ScopedModelDescendant<TopUpPageModel>(
              builder: (_, child, model){

                return new Container(
                  height: 50.0,
                  child: Material(
                    color: model.isWebViewOpened ? new Color(0xff009cde): MyColors.mainRed,
                    child: new StoreConnector<AppState,String>(
                      converter: (store) => store.state.currentUser.uid,
                      builder: (context,uid) => new InkWell(
                        onTap: () {
                          // show web view
                          if (model.isWebViewOpened) {
                            model.toggleIsWebViewOpened();
                            flutterWebviewPlugin.close();
                          } else {
                            model.toggleIsWebViewOpened();
                            String url;
                            switch(model.amount) {
                              case Amount.TIER1:
                                url = topUpUrl1000 + uid;
                                break;
                              case Amount.TIER2:
                                url = topUpUrl2000 + uid;
                                break;
                              case Amount.TIER3:
                                url = topUpUrl5000 + uid;
                                break;
                              case Amount.TIER4:
                                url = topUpUrl10000 + uid;
                                break;
                            }   
                            flutterWebviewPlugin.launch(url, rect: new Rect.fromLTWH(
                              0.0,
                              0.0,
                              MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height - 50));
                            }
                          },
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: new Text(
                                  "${model.isWebViewOpened ? 'Back To Top Up Page' : 'Top Up'}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                    )
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }


}

class TopUpRadioButton extends StatefulWidget {
  Amount selectedAmount;
  String text;
  TopUpRadioButton(this.selectedAmount, this.text);

  @override
  _TopUpRadioButtonState createState() {
    return _TopUpRadioButtonState();
  }
}
class _TopUpRadioButtonState extends State<TopUpRadioButton>{


  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: ScopedModelDescendant<TopUpPageModel>(
        builder: (_, child, model){
          return InkWell(
            onTap: () {

                model.setAmount(widget.selectedAmount);

            },
            child: new Container(
              child: Center(
                child: new Text("\$${widget.text}",
                  style: new TextStyle(
                      fontSize: 25.0
                  ),
                ),
              ),
              decoration: new BoxDecoration(

                  border: new Border.all(
                    width: 2.5,
                    color: widget.selectedAmount == model.amount ? MyColors.mainRed : Colors.grey,
                  ),
                  borderRadius: new BorderRadius.circular(12.0)
              ),
              height: 110.0,
            ),
          );
        },
      ),
    );
  }
}

class TopUpPageModel extends Model {
  Amount selectedAmount;

  bool isWebViewOpened = false;

  Amount get amount => selectedAmount;

  TopUpPageModel(this.selectedAmount);

  void setAmount(Amount amount) {
    selectedAmount = amount;
    notifyListeners();
  }

  void toggleIsWebViewOpened(){
    isWebViewOpened = !isWebViewOpened;
    notifyListeners();
  }

}