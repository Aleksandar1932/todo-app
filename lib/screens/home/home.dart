import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/user.dart';
import 'package:todo/screens/home/speed_dial_fab.dart';
import 'package:todo/screens/home/tasks/todo_tasks.dart';
import 'package:todo/screens/home/tasks/done_tasks.dart';
import 'package:todo/services/auth.dart';
import 'package:todo/services/database.dart';
import 'package:todo/shared/app_bar.dart';
import 'package:todo/shared/constants.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/rendering.dart';

import 'package:dart_json_mapper/dart_json_mapper.dart' show JsonMapper, jsonSerializable, JsonProperty;

class Home extends StatefulWidget {
  final User currentUser;

  Home({this.currentUser});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPageIndex = 0;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Task>>.value(
      initialData: [],
      value: DatabaseService().getUserTasks(widget.currentUser.uid),
      child: Scaffold(
//          appBar: AppBar(
//            actions: [
//              IconButton(
//                icon: Icon(Icons.exit_to_app),
//                onPressed: () {
//                  AuthService().signOut();
//                },
//              )
//            ],
//            title: Text("$APP_NAME"),
//            centerTitle: true,
//            elevation: 0,
//          ),
          appBar: ToDoAppBar(
            isHome: true,
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (newIndex) {
              setState(() {
                _currentPageIndex = newIndex;
              });
            },
            children: <Widget>[
              SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  ToDoTasks(),
                ],
              )),
              SingleChildScrollView(
                child: Column(
                  children: [DoneTasks()],
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                title: Text('ToDo'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.done),
                title: Text('Done'),
              ),
            ],
            currentIndex: _currentPageIndex,
            onTap: (newIndex) {
              _pageController.animateToPage(newIndex, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
              setState(() {
                _currentPageIndex = newIndex;
              });
            },
          ),
          floatingActionButton: SpeedDialFAB()),
    );
  }
}
