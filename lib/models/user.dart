import 'package:dart_json_mapper/dart_json_mapper.dart' show JsonMapper, jsonSerializable, JsonProperty;
import 'package:reflectable/reflectable.dart';

@jsonSerializable
class User {
  @JsonProperty(name: 'uid')
  final String uid;
  final String email;
  final String displayName;

  User({this.uid, this.email, this.displayName});

}
