import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> buscarCep(String cep) async {
  final tratamentoString = cep.replaceAll(RegExp(r'[^0-9]'), '');
  if (tratamentoString.length != 8) {
    throw Exception('CEP deve ter 8 dígitos');
  }

  final url = Uri.parse('https://viacep.com.br/ws/$tratamentoString/json/');
  final resposta = await http.get(url).timeout(Duration(seconds: 10));

  if (resposta.statusCode == 200) {
    final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
    if (dados.containsKey('erro') && dados['erro'] == true) {
      throw Exception('CEP não encontrado');
    }
    return dados;
  } else {
    throw Exception('Erro na requisição: ${resposta.statusCode}');
  }
}
