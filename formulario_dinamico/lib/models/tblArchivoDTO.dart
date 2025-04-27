class TblArchivoDTO {
  final int idArchivo;
  final String? nombreArchivo;
  final String? archivo;

  TblArchivoDTO({required this.idArchivo, required this.nombreArchivo, required this.archivo});

  factory TblArchivoDTO.fromJson(Map<String, dynamic> json) {
    return TblArchivoDTO(
      idArchivo: json['idArchivo'],
      nombreArchivo: json['nombreArchivo'],
      archivo: json['archivo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idArchivo': idArchivo,
      'nombreArchivo': nombreArchivo,
      'archivo': archivo,
    };
  }

  @override
  String toString() =>
      'TblArchivoDTO(idArchivo: $idArchivo, nombreArchivo: $nombreArchivo, archivo: $archivo)';
}
