import 'package:flutter/material.dart';
import 'package:formulario_dinamico/enums/tipoResultado.dart';
import 'package:formulario_dinamico/services/formService.dart';
import 'package:formulario_dinamico/models/formDTO.dart';

class PruebaWidget extends StatefulWidget {
  const PruebaWidget({super.key});

  @override
  State<PruebaWidget> createState() => _PruebaWidgetState();
}

class _PruebaWidgetState extends State<PruebaWidget> {
  final formularioService = FormService();
  List<FormDTO> _lstFormDTO = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _listarFormulario();
  }

  void _listarFormulario() async {
    final respuesta = await formularioService.listarFormulario();

    if (respuesta.tipoResultado == TipoResultado.success) {
      final lstFormDTO = List<FormDTO>.from((respuesta.lista as List).map((model) => FormDTO.fromJson(model)),
      );
      setState(() {
        _lstFormDTO = lstFormDTO;
        _isLoading = false;
      });
    } else {
      throw Exception('Error al listar formulario: ${respuesta.mensaje}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acordeón Dinámico')),
      body: ListView(
        children:
            _lstFormDTO.map((item) {
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
