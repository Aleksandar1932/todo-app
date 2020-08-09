import 'package:flutter/material.dart';
import 'package:todo/screens/wrapper.dart';
import 'package:todo/services/auth.dart';
import 'package:provider/provider.dart';

import 'main.reflectable.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeReflectable();
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              scaffoldBackgroundColor: Colors.grey[100],
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: TextTheme(
                headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                headline2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                headline3: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                bodyText1: TextStyle(fontSize: 16.0),
                bodyText2: TextStyle(fontSize: 14.0),
              )),
          darkTheme: ThemeData(
            primarySwatch: Colors.grey,
            primaryColor: Colors.grey[900],
            scaffoldBackgroundColor: Colors.grey[800],
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.grey[400],
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.grey[900],
                selectedItemColor: Colors.grey[100],
                unselectedItemColor: Colors.grey[500]),
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[100]),
              headline2: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[100]),
              headline3: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[100]),
              bodyText1: TextStyle(fontSize: 16.0, color: Colors.grey[100]),
              bodyText2: TextStyle(fontSize: 14.0, color: Colors.grey[100]),
            ),
            cardTheme: CardTheme(
              color: Colors.grey[850],
            ),
            iconTheme: IconThemeData(color: Colors.grey[400]),
          ),
          themeMode: ThemeMode.light,
          home: Wrapper()),
    );
  }
}
