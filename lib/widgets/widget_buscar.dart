import 'package:flutter/material.dart';
import 'package:localiza_cep/models/cep_model.dart';

class ResultadoCard extends StatelessWidget {
  final String? erro;
  final bool carregando;
  final CepModel? cepModel;

  const ResultadoCard({
    super.key,
    this.cepModel,
    this.erro,
    this.carregando = false,
  });

  @override
  Widget build(BuildContext context) {
    if (carregando) return const LinearProgressIndicator();
    if (erro != null) {
      return Text(
        erro!,
        style: const TextStyle(color: Color(0xFFFF435B), fontSize: 18),
      );
    }
    if (cepModel == null) {
      return const Text(
        "Nenhum CEP buscado ainda",
        style: TextStyle(color: Color(0xFFFF435B), fontSize: 18),
      );
    }

    return Card(
      color: const Color(0xFFFDFBD4),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CEP: ${cepModel!.cep}',
              style: const TextStyle(
                fontSize: 32,
                color: Color(0xFFFF435B),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Logradouro: ${cepModel!.logradouro}'),
            Text('Bairro: ${cepModel!.bairro}'),
            Text('Cidade: ${cepModel!.localidade}'),
            Text('UF: ${cepModel!.uf}'),
          ],
        ),
      ),
    );
  }
}
