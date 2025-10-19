import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localiza_cep/models/cep_model.dart';
import '../services/via_cep_api.dart';
import 'package:localiza_cep/widgets/widget_buscar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controllerCep = TextEditingController();
  CepModel? _cepModel;
  String? _erro;
  bool _carregando = false;

  @override
  void dispose() {
    _controllerCep.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    FocusScope.of(context).unfocus();
    final cep = _controllerCep.text.trim();

    if (cep.length != 8 || int.tryParse(cep) == null) {
      setState(() => _erro = "CEP deve conter exatamente 8 dígitos numéricos");
      return;
    }

    setState(() {
      _carregando = true;
      _cepModel = null;
      _erro = null;
    });

    try {
      final dados = await buscarCep(cep);
      setState(() {
        _cepModel = CepModel.fromJson(dados);
        _erro = null;
      });
    } catch (e) {
      setState(() => _erro = "Erro ao buscar CEP: ${e.toString()}");
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFF435B),
        title: const Text(
          "Localize CEPs brasileiros",
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLarge = constraints.maxWidth > 900;

              final inputArea = _buildInputArea();
              final resultadoWidget = ResultadoCard(
                cepModel: _cepModel,
                erro: _erro,
                carregando: _carregando,
              );

              if (isLarge) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: inputArea),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: resultadoWidget),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 2,
                      child: Image.asset('assets/mapa.png', fit: BoxFit.cover),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  inputArea,
                  const SizedBox(height: 32),
                  resultadoWidget,
                  const SizedBox(height: 32),
                  Image.asset('assets/mapa.png'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: "Digite o ",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "CEP",
                style: TextStyle(color: Color(0xFFBDE65D)),
              ),
              TextSpan(text: " e\nobtenha informações"),
            ],
          ),
        ),
        const SizedBox(height: 40),
        TextField(
          controller: _controllerCep,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(8),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromRGBO(255, 204, 0, 0.5),
            hintText: "Informe o CEP (Apenas números)",
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _buscar(),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _carregando ? null : _buscar,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFCD00),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _carregando
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 3,
                    ),
                  )
                : const Text(
                    "Buscar",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
