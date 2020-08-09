import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/database.dart';
import 'package:todo/shared/constants.dart';
import 'package:todo/shared/loading.dart';
import 'package:intl/intl.dart';

class TasksList extends StatefulWidget {
  final List<Task> tasks;

  final bool areToDos;

  TasksList({this.tasks, this.areToDos});

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final DateFormat dateFormatter = DateFormat('dd MMM yyyy' ' @' ' H:mm');
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (widget.tasks == null) {
      return Loading();
    } else {
      if (widget.tasks.isEmpty) {
        return Text(widget.areToDos ? "$TODO_TASKS_NO_TASKS" : "$DONE_TASKS_NO_TASKS", style: Theme.of(context).textTheme.headline1,);
      } else
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Text(
                    widget.areToDos ? TODO_TASKS_HEADING : DONE_TASKS_HEADING,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Divider(),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: widget.tasks.length,
                      itemBuilder: (context, index) {
                        Task currentTask = widget.tasks.elementAt(index);
                        return Column(
                          children: [
                            Card(
                              color: currentTask.isDone ? DONE_TASK_COLOR : null,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Row(
                                      children: [
                                        Icon(Icons.title),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          currentTask.title,
                                          style: Theme.of(context).textTheme.headline3,
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      children: [
                                        currentTask.description.isNotEmpty
                                            ? Row(
                                                children: [
                                                  Icon(Icons.subject),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    currentTask.description,
                                                    style: Theme.of(context).textTheme.bodyText1,
                                                  ),
                                                ],
                                              )
                                            : SizedBox.shrink(),
                                        Row(
                                          children: [
                                            Icon(Icons.access_alarms),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              dateFormatter.format(currentTask.due).toString(),
                                              style: Theme.of(context).textTheme.bodyText2,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.category),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              currentTask.category.name.toString(),
                                              style: Theme.of(context).textTheme.bodyText2,
                                            ),
                                          ],
                                        ),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    ),
                                    trailing: FlatButton.icon(
                                      onPressed: currentTask.isDone
                                          ? () async {
                                              await DatabaseService()
                                                  .undoFinishedTask(CURRENT_USER, currentTask.taskId);
                                            }
                                          : () async {
                                              await DatabaseService().finishTask(CURRENT_USER, currentTask.taskId);
                                            },
                                      icon: currentTask.isDone
                                          ? Icon(Icons.check_box)
                                          : Icon(Icons.check_box_outline_blank),
                                      label: SizedBox.shrink(),
                                      padding: EdgeInsets.all(0),
                                    ),
                                    onLongPress: () {
                                      _showDeleteTaskConfirmationDialog(currentTask);
                                      print("Try to delete ${currentTask.taskId}");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      })
                ],
              )),
        );
    }
  }

  Future<void> _showDeleteTaskConfirmationDialog(Task taskToDelete) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to delete the following task?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.title),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          taskToDelete.title,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                    taskToDelete.description.isNotEmpty
                        ? Row(
                            children: [
                              Icon(Icons.subject),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                taskToDelete.description,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Delete'),
              onPressed: () async {
                await DatabaseService().removeTaskFromUserTasks(CURRENT_USER, taskToDelete);
                Navigator.of(context).pop();
//              print(taskToDelete.category.id);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
