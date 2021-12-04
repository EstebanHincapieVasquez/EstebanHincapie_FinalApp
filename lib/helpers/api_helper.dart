import 'dart:convert';

import 'package:aplicacion_final_app/models/token.dart';
import 'package:http/http.dart' as http;

import 'package:aplicacion_final_app/helpers/constants.dart';
import 'package:aplicacion_final_app/models/response.dart';

class ApiHelper {

  static Future<Response> post(String controller, Map<String, dynamic> request, Token token) async {
    if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer ${token.token}',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

  static Future<Response> postNoToken(String controller, Map<String, dynamic> request) async {
    
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

  static bool _validToken(Token token) {
    if (DateTime.parse(token.expiration).isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }
  

}