import 'package:fpdart/fpdart.dart';
import 'package:task_manager/utils/error.dart';

class Category {
  final int id;
  String name;
  final DateTime createdAt;
  DateTime updatedAt;

  Category(this.id, this.name, this.createdAt, this.updatedAt);

  static Either<JsonParseError, Category> fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    DateTime createdAt;
    DateTime updatedAt;

    if (json.keys.toList() == ['id', 'name', 'createdAt', 'updatedAt']) {
      return Either.left(JsonParseError.missingKeyError);
    }
    if (json.containsValue(null)) {
      return Either.left(JsonParseError.nullValueError);
    }
    if (id is! int || name is! String) {
      return Either.left(JsonParseError.typeError);
    } else {
      try {
        createdAt = DateTime.parse(json['createdAt']);
        updatedAt = DateTime.parse(json['createdAt']);
      } catch (exception) {
        return Either.left(JsonParseError.typeError);
      }
    }
    return Either.right(Category(id, name, createdAt, updatedAt));
  }
}
