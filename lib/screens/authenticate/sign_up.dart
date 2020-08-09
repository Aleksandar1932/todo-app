import 'package:flutter/material.dart';
import 'package:todo/services/auth.dart';
import 'package:todo/shared/app_bar.dart';
import 'package:todo/shared/constants.dart';
import 'package:todo/shared/loading.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  String _displayName = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  bool loading = false;

  String error = '';

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
                            onChanged: (text) {
                              setState(() {
                                _displayName = text;
                              });
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: "Your name",
                            ),
                            validator: (value) => value.isEmpty ? "Enter your name" : null,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) => value.isEmpty ? "Enter your email" : null,
                            onChanged: (text) {
                              setState(() {
                                _email = text;
                              });
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: "Your email",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: true,
                            onChanged: (text) {
                              setState(() {
                                _password = text;
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
                              hintText: "Your password",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: true,
                            onChanged: (text) {
                              setState(() {
                                _confirmPassword = text;
                              });
                            },
                            validator: (value) {
                              if (value != _password) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.repeat),
                              hintText: "Confirm your password",
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
                                  dynamic result = AuthService()
                                      .signUpUserWithEmailPasswordAndDisplayName(_email, _password, _displayName);

                                  if (result == null) {
                                    // error from firebase registration
                                    setState(() {
                                      error = "Please supply valid credentials";
                                      loading = false;
                                    });
                                  }
                                  // form is valid
                                } else {
                                  // form is invalid
                                }
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          )
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
                      Text("Already have an account? "),
                      InkWell(
                        child: Text(
                          "Sign In",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          widget.toggleView();
                        },
                      ),
                    ],
                  ),
                  Text("$error")
                ],
              ),
            ),
          );
  }
}
