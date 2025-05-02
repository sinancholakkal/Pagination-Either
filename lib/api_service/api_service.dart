import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:pagination_with_either/api_service/model.dart';

class ApiService {
  static Future<Either<String, List<Model>>> fetchData(int page) async {
    const String apiEndPoint = "https://jsonplaceholder.typicode.com";
    try {
      final response = await http.get(
        Uri.parse("$apiEndPoint/posts?_page=$page&_limit=10"),
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);
        return Right(
          responseBody.map((data) {
            return Model.fromJson(data);
          }).toList(),
        );
      } else {
        return const Left("Server Failure");
      }
    } catch (e) {
      return Left("Something issue while fetch data in API service $e");
    }
  }
}

// final List<dynamic> responseBody= json.decode(response.body);
//      responseBody.map((data){
//       return Model.fromJson(data);
//     }).toList();
