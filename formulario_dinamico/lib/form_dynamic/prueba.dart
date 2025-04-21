import 'package:flutter/material.dart';
import 'package:formulario_dinamico/services/formService.dart';
import 'package:formulario_dinamico/models/formDTO.dart';

class PruebaWidget extends StatefulWidget {
  const PruebaWidget({super.key});

  @override
  State<PruebaWidget> createState() => _PruebaWidgetState();
}

class _PruebaWidgetState extends State<PruebaWidget> {
  final formularioService = FormService();
  List<FormDTO> _formularios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _listarFormulario();
  }

  void _listarFormulario() async {
    List<FormDTO> lista = await formularioService.listarFormulario();
    print(lista);
    setState(() {
      _formularios = lista;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acordeón Dinámico')),
      body: ListView(
        children:
            _formularios.map((item) {
              return ExpansionTile(
                title: Text(item.name ?? ''),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Hola a todos" ?? ''),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}
