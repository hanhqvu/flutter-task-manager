import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:task_manager/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/utils/env.dart';
import 'package:task_manager/utils/error.dart';

class NetworkManager {
  NetworkManager._();

  static final instance = NetworkManager._();

  static final String apiUri = Env.apiUri;

  Future<Either<NetworkError, List<Category>>> fetchCategories() async {
    final response = await http.get(Uri.parse('$apiUri/categories'));

    switch (response.statusCode) {
      case (200):
        final List categoriesJson = jsonDecode(response.body);
        final parsedResults = categoriesJson
            .map((categoryJson) =>
                Category.fromJson(categoryJson as Map<String, dynamic>))
            .toList();
        if (parsedResults.every((result) => result.isRight())) {
          return Either.right(Either.rights(parsedResults));
        }
        return Either.left(NetworkError.parseError);
      case (500):
        return Either.left(NetworkError.serverError);
      default:
        return Either.left(NetworkError.unknownError);
    }
  }
}
