class DetalleExcepcionDTO {
  final String proceso;
  final String objetoTrabajo;
  final String ubicacion;
  final String mensajeInfraResumen;
  final List<String> listAcciones;

  DetalleExcepcionDTO({
    required this.proceso,
    required this.objetoTrabajo,
    required this.ubicacion,
    required this.mensajeInfraResumen,
    required this.listAcciones,
  });

  factory DetalleExcepcionDTO.fromJson(Map<String, dynamic> json) {
    return DetalleExcepcionDTO(
      proceso: json['proceso'],
      objetoTrabajo: json['objetoTrabajo'],
      ubicacion: json['ubicacion'],
      mensajeInfraResumen: json['mensajeInfraResumen'],
      listAcciones: List<String>.from(json['listAcciones']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proceso': proceso,
      'objetoTrabajo': objetoTrabajo,
      'ubicacion': ubicacion,
      'mensajeInfraResumen': mensajeInfraResumen,
      'listAcciones': listAcciones,
    };
  }

  @override
  String toString() {
    return 'DetalleExcepcionDTO(proceso: $proceso, objetoTrabajo: $objetoTrabajo, ubicacion: $ubicacion, mensajeInfraResumen: $mensajeInfraResumen, listAcciones: $listAcciones)';
  }
}
