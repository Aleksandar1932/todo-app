import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/user.dart';
import 'package:todo/services/database.dart';
import 'package:todo/shared/app_bar.dart';
import 'package:todo/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/loading.dart';

class AddNewTask extends StatefulWidget {
  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  // widget constant variables
  final _formKey = GlobalKey<FormState>();
  final DateFormat dateFormatter = DateFormat('dd MMM yyyy');
  List<TaskCategory> allUserCategories;
  final TextEditingController _dueDatePickerController = TextEditingController();
  final TextEditingController _dueTimePickerController = TextEditingController();

  // state variables
  String _currentTitle = '';
  String _currentDescription = '';
  DateTime _currentDueOnlyDate = DateTime.now().add(Duration(days: INITIAL_DATE_DAYS_OFFSET));
  TimeOfDay _currentDueOnlyTime = TimeOfDay.now();
  DateTime _taskDueDate;
  String _currentCategoryId;

  void _getUserCategories() async {
    List<TaskCategory> categories = await DatabaseService().getAllUserCategoriesNames(CURRENT_USER);

    setState(() {
      allUserCategories = categories;
      _currentCategoryId = categories[0].id.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dueDatePickerController.text = dateFormatter.format(_currentDueOnlyDate).toString();
    _dueTimePickerController.text = _formatTimeOfDayToHourDotMinute(_currentDueOnlyTime);

    _getUserCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ToDoAppBar(
        isHome: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add new task",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            _currentTitle = text;
                          });
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.title),
                          labelText: "Title",
                          hintText: "Please chose the task's title",
                        ),
                        validator: (value) => value.isEmpty ? "Enter task title" : null,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            _currentDescription = text;
                          });
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.subject),
                          labelText: "Description",
                          hintText: "Please chose the task's description",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: _dueDatePickerController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.date_range),
                          hintText: "Due date",
                        ),
                        onTap: () async {
                          await _pickDate();
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: _dueTimePickerController,
                        onTap: () async {
                          await _pickTime();
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.access_time),
                          hintText: "Due time",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      allUserCategories == null
                          ? Loading()
                          : Row(
                              children: [
                                Icon(Icons.category),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    child: DropdownButton<String>(
                                        value: _currentCategoryId,
                                        icon: Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(color: Colors.deepPurple),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String newValue) async {
                                          setState(() {
                                            _currentCategoryId = newValue;
                                          });
                                        },
                                        items: allUserCategories
                                            .map((category) => DropdownMenuItem(
                                                  value: category.id.toString(),
                                                  child: Text(category.name.toString()),
                                                ))
                                            .toList()),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 40,
                      ),
                      FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _taskDueDate = DateTime(_currentDueOnlyDate.year, _currentDueOnlyDate.month,
                                _currentDueOnlyDate.day, _currentDueOnlyTime.hour, _currentDueOnlyTime.minute);

                            TaskCategory currentCategory =
                                allUserCategories.where((element) => element.id == _currentCategoryId).first;

                            Task taskToAdd = Task(
                                title: _currentTitle.toString(),
                                description: _currentDescription,
                                due: _taskDueDate,
                                isDone: false,
                                category: currentCategory);

                            await DatabaseService().addNewTaskToUserTasks(CURRENT_USER, taskToAdd).catchError((error) {
                              print(error.toString());
                            });

//                            await DatabaseService().addTaskToCategory(currentCategory, CURRENT_USER, taskToAdd);

                            Navigator.pop(context);
                          } else {
                            // invalid form
                          }
                        },
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: _currentDueOnlyDate,
    );
    if (date != null)
      setState(() {
        _currentDueOnlyDate = date;
        _dueDatePickerController.text = dateFormatter.format(_currentDueOnlyDate).toString();
      });
  }

  _pickTime() async {
    TimeOfDay time = await showTimePicker(context: context, initialTime: _currentDueOnlyTime);
    if (time != null)
      setState(() {
        _currentDueOnlyTime = time;
        _dueTimePickerController.text = _formatTimeOfDayToHourDotMinute(_currentDueOnlyTime);
      });
  }

  String _formatTimeOfDayToHourDotMinute(TimeOfDay timeOfDay) {
    return "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";
  }
}
