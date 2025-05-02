import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart'as http;
import 'package:pagination_with_either/api_service/model.dart';

class ApiService {

  static Future<List<Model>>fetchData(int page)async{
    const String apiEndPoint = "https://jsonplaceholder.typicode.com";
    final response =await http.get(Uri.parse("$apiEndPoint/posts?_page=$page&_limit=10"));
    final List<dynamic> responseBody= json.decode(response.body);
    return responseBody.map((data){
      return Model.fromJson(data);
    }).toList();
  }
  
}
