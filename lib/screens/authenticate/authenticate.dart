import 'package:flutter/material.dart';
import 'package:todo/screens/authenticate/sign_in.dart';
import 'package:todo/screens/authenticate/sign_up.dart';
import 'package:todo/shared/loading.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn ? SignIn(toggleView: toggleView,) : SignUp(toggleView: toggleView,);
//  return Loading();
  }
}
