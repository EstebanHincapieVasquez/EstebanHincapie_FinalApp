import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:aplicacion_final_app/helpers/constants.dart';
import 'package:aplicacion_final_app/models/data.dart';
import 'package:aplicacion_final_app/models/response.dart';

class ApiHelper {
  
  static Future<Response> getNotices() async {
    var url = Uri.parse(Constants.apiUrl);
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Data> list = [];    
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson['data']) {
        list.add(Data.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  static Future<Response> getAllNotices() async {
    var url = Uri.parse('${Constants.apiUrl}all');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Data> list = [];    
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson['data']) {
        list.add(Data.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

}