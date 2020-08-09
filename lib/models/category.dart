import 'package:todo/models/task.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart' show JsonMapper, jsonSerializable, JsonProperty;
import 'package:reflectable/reflectable.dart';

@jsonSerializable
class TaskCategory {
  String id = '';
  String name;

  TaskCategory({this.name});
  TaskCategory.getAllCategories({this.id, this.name});
}
