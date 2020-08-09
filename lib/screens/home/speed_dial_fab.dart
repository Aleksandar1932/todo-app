import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:todo/screens/home/categories/add_new_category.dart';
import 'package:todo/screens/home/tasks/add_new_task.dart';

class SpeedDialFAB extends StatelessWidget {
  bool dialVisible = true;
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      elevation: 0,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
//      onOpen: () => print('OPENING DIAL'),
//      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.grey,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewTask())),
          label: 'Add new task',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
//          labelBackgroundColor: Colors.deepOrangeAccent,
        ),SpeedDialChild(
          child: Icon(Icons.category, color: Colors.white),
          backgroundColor: Colors.grey,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewCategory())),
          label: 'Add new category',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
//          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
      ],
    );
  }
}
