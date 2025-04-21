import 'dart:convert';
import 'package:formulario_dinamico/models/formDTO.dart';
import 'package:formulario_dinamico/utils/apiRoutes.dart';
import 'package:http/http.dart' as http;

class FormService {
  static const String baseUrl = '${ApiRoutes.baseUrl}/api/formularios';

  Future<List<FormDTO>> listarFormulario() async {
    final response = await http.get(Uri.parse('$baseUrl/listarFormulario'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> listaJson = data['lista'];
      // return listaJson.map((model) => FormDTO.fromJson(model)).toList();
      return List<FormDTO>.from(listaJson.map((model) => FormDTO.fromJson(model)));
    } else {
      throw Exception('Error al conectar con la API listarFormulario');
    }
  }
}
