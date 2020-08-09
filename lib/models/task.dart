import 'package:dart_json_mapper/dart_json_mapper.dart' show JsonMapper, jsonSerializable, JsonProperty;
import 'package:flutter/foundation.dart';
import 'package:reflectable/reflectable.dart';
import 'package:todo/models/category.dart';

@jsonSerializable
class Task {
  String taskId = '';
  String title;
  String description;
  DateTime due;
  TaskCategory category;
  bool isDone;

  Task({this.title, this.description, this.due, this.category, this.isDone});

  Task.fromStream({this.taskId, this.title, this.description, this.due, this.category, this.isDone});


}