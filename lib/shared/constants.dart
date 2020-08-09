import 'package:flutter/cupertino.dart';
import 'package:todo/models/user.dart';
import 'package:flutter/material.dart';

const String APP_NAME = "ToDo";
const int MIN_PASSWORD_LENGTH = 8;

Color DONE_TASK_COLOR = Colors.purple[300];

User CURRENT_USER = null;
// Date picker
// Always initial date is the next date (day)
const INITIAL_DATE_DAYS_OFFSET = 1;

const String TODO_TASKS_HEADING = "Tasks to do";
const String DONE_TASKS_HEADING = "Done tasks";

const String TODO_TASKS_NO_TASKS = "You haven't added any tasks!";
const String DONE_TASKS_NO_TASKS = "You've done all of your tasks!";

const String DEFAULT_CATEGORY_NAME = "Personal";
