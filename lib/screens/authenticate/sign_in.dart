import 'package:flutter/material.dart';
import 'package:todo/exceptions/FailedSignInException.dart';
import 'package:todo/services/auth.dart';
import 'package:todo/shared/app_bar.dart';
import 'package:todo/shared/constants.dart';
import 'package:todo/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  String _currentEmail = "";
  String _currentPassword = "";
  String _errorMessage = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: ToDoAppBar(isHome: false,),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (value) => value.isEmpty ? "Enter your email" : null,
                            onChanged: (text) {
                              setState(() {
                                _currentEmail = text;
                              });
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: "Email",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: true,
                            onChanged: (text) {
                              setState(() {
                                _currentPassword = text;
                              });
                            },
                            validator: (value) {
                              if (value.length < MIN_PASSWORD_LENGTH) {
                                return "Your password must be at least $MIN_PASSWORD_LENGTH characters long";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: "Password",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ButtonTheme(
                            minWidth: double.infinity,
                            child: RaisedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  // form is valid

                                  dynamic result = AuthService()
                                      .signInUserWithEmailAndPassword(_currentEmail, _currentPassword)
                                      .catchError((error) {
                                    setState(() {
                                      _errorMessage = error.toString();
                                      loading = false;
                                    });
                                  });
                                } else {
                                  // form is invalid
                                }
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Text(_errorMessage)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account? "),
                      InkWell(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          widget.toggleView();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
