import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/screens/home/tasks/tasks_list_builder.dart';
import 'package:todo/services/database.dart';
import 'package:todo/shared/constants.dart';
import 'package:todo/shared/loading.dart';

class DoneTasks extends StatefulWidget {
  @override
  _DoneTasksState createState() => _DoneTasksState();
}

class _DoneTasksState extends State<DoneTasks> with AutomaticKeepAliveClientMixin<DoneTasks> {
  //state variables
  GlobalKey _menuKey = new GlobalKey();

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    final List<Task> tasks = Provider.of<List<Task>>(context).where((task) => task.isDone).toList();
    return tasks != null
        ? TasksList(
            areToDos: false,
            tasks: tasks,
          )
        : Loading();
  }

  @override
  bool get wantKeepAlive => true;
}
