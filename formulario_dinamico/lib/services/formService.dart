import 'dart:convert';
import 'package:formulario_dinamico/config/enviroment.dart';
import 'package:formulario_dinamico/models/responseDTO.dart';
import 'package:formulario_dinamico/models/tblArchivoDTO.dart';
import 'package:http/http.dart' as http;

class FormService {
  static const String baseUrl = '${Enviroment.baseUrl}/api/formularios';

  Future<ResponseDTO> listarFormulario() async {
    final response = await http.get(Uri.parse('$baseUrl/listarFormulario'));
    final Map<String, dynamic> respuesta = json.decode(
      utf8.decode(response.bodyBytes),
    );

    if (response.statusCode == 200) {
      return ResponseDTO.fromJson(respuesta);
      // final List<dynamic> lstFormDTO = respuesta['lista'];
      // return lstFormDTO.map((model) => FormDTO.fromJson(model)).toList();
      // return List<FormDTO>.from(lstFormDTO.map((model) => FormDTO.fromJson(model)));
    } else {
      throw Exception('Error al conectar con la API listarFormulario');
    }
  }

  Future<ResponseDTO> enviarArchivo(TblArchivoDTO archivoDTO) async {
    final url = Uri.parse('$baseUrl/crearArchivo');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(archivoDTO.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return ResponseDTO.fromJson(jsonResponse);
    } else {
      throw Exception('Error al conectar con la API');
    }
  }
}
