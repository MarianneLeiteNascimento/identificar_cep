import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Back4app {
  static final _appId = dotenv.env['_appId']!;
  static final _restApiKey = dotenv.env['_restApiKey']!;
  static final _baseUrl = dotenv.env['_baseUrl']!;

  static Map<String, String> get _headers => {
    'X-Parse-Application-Id': _appId,
    'X-Parse-REST-API-Key': _restApiKey,
    'Content-Type': 'application/json',
  };

  static Future<Map<String, dynamic>?> buscarCep(String cep) async {
    final url = Uri.parse('$_baseUrl?where={"cep":"$cep"}');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        return data['results'][0];
      }
    }
    return null;
  }

  static Future<void> cadastrarCep(Map<String, dynamic> cepData) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: _headers,
      body: jsonEncode(cepData),
    );
    debugPrint(response.body);
  }

  static Future<List<Map<String, dynamic>>> listarCeps() async {
    final response = await http.get(Uri.parse(_baseUrl), headers: _headers);
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  static Future<void> excluirCep(String objectId) async {
    final url = Uri.parse('$_baseUrl/$objectId');
    await http.delete(url, headers: _headers);
  }

  static Future<void> atualizarCep(
    String objectId,
    Map<String, dynamic> novosDados,
  ) async {
    final url = Uri.parse('$_baseUrl/$objectId');
    await http.put(url, headers: _headers, body: jsonEncode(novosDados));
  }
}
