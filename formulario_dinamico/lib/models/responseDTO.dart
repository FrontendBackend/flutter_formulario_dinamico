import 'package:formulario_dinamico/enums/tipoResultado.dart';
import 'package:formulario_dinamico/models/detalleExcepcionDTO.dart';

class ResponseDTO {
  
  final int? length;
  final String? status;
  final dynamic data;
  final String? mensaje;
  final dynamic lista;
  final DateTime timestamp;
  final int? id;
  final double? valor;
  final TipoResultado tipoResultado;
  final String? tipoResultadoCadena;
  final DetalleExcepcionDTO? detalleExcepcionDTO;

  ResponseDTO({
    required this.length,
    required this.status,
    required this.data,
    required this.mensaje,
    required this.lista,
    required this.timestamp,
    required this.id,
    required this.valor,
    required this.tipoResultado,
    required this.tipoResultadoCadena,
    this.detalleExcepcionDTO,
  });

  factory ResponseDTO.fromJson(Map<String, dynamic> json) {
    return ResponseDTO(
      length: json['length'],
      status: json['status'],
      data: json['data'],
      mensaje: json['mensaje'],
      lista: json['lista'],
      timestamp: DateTime.parse(json['timestamp']),
      id: json['id'],
      valor: json['valor'],
      tipoResultado: TipoResultado.fromString(json['tipoResultado']),
      tipoResultadoCadena: json['tipoResultadoCadena'],
      detalleExcepcionDTO: json['detalleExcepcionDTO'] != null ? DetalleExcepcionDTO.fromJson(json['detalleExcepcionDTO']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'status': status,
      'data': data,
      'mensaje': mensaje,
      'lista': lista,
      'timestamp': timestamp.toIso8601String(),
      'id': id,
      'valor': valor,
      'tipoResultado': tipoResultado.value,
      'tipoResultadoCadena': tipoResultadoCadena,
      'detalleExcepcionDTO': detalleExcepcionDTO?.toJson(),
    };
  }

  @override
  String toString() {
    return 'ResponseDTO(status: $status, mensaje: $mensaje, tipoResultado: ${tipoResultado.value}, data: $data), lista: $lista';
  }
}