import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


import 'package:sambl/async_action/google_authentication.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/widgets/shared/my_color.dart';

class SignInPage extends StatelessWidget {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState,AppStatusFlags> (
    converter: (store) {
      return store.state.currentAppStatus;
    },
    builder: (context,status) {
      if (false/*status != AppStatusFlags.unauthenticated*/) {
        print("in sign in page, unauthenticated.");
        //Navigator.of(context).popUntil(ModalRoute.withName('/'));
        //return defaultPage(status);
      } else {
        return new Scaffold(
          key: _formKey,
          body: new Stack(
            children: <Widget>[
              new Container(
                color: Colors.black,  
                child: new Image(   
                  colorBlendMode: BlendMode.darken,
                  color: Colors.black38,
                  image: AssetImage('assets/images/sign_in_page_background.jpg'),
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  alignment: new FractionalOffset(0.0, 0.0),
                ),
              ),

              // SamBl title
              new Positioned(
                top: 150.0,
                left: 50.0,
                right: 50.0,
                child: new Center(
                  child: new Text("Sambl",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 80.0
                    ),
                  ),
                )
              ),

              // Sign In With Google button
              new Positioned(
                bottom: 50.0,
                left: 50.0,
                right: 50.0,
                child: new Container(
                  height: 60.0,
                  child: new StoreConnector<AppState,VoidCallback>(
                    converter: (store) => () async {
                      store.dispatch(signInWithGoogleAction);
                    },
                    builder: (context,callback) => Material(
                      borderRadius: new BorderRadius.circular(30.0),
                      color: MyColors.mainRed,
                      child: new InkWell(
                        borderRadius: new BorderRadius.circular(30.0),
                        splashColor: MyColors.mainBackground,
                        child: new Center(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("G",
                                style: const TextStyle(
                                  fontFamily: "Futura",
                                  fontSize: 40.0,
                                  color: Colors.white
                                ),
                              ),
                              // vertical divider
                              new Container(
                                margin: new EdgeInsets.symmetric(horizontal: 10.0),
                                height: 40.0,
                                width: 1.5,
                                color: Colors.white,
                              ),
                              const Text("SIGN IN WITH GOOGLE",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        onTap: callback
                      ),
                    )

                  )
                ),
              )
            ],
          ),
        );
      }
    }
  );

}