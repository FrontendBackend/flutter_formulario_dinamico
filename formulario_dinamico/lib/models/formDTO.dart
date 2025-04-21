class FormDTO {
  final int idForm;
  final String name;

  FormDTO({
    required this.idForm, 
    required this.name
  });

  factory FormDTO.fromJson(Map<String, dynamic> json) {
    return FormDTO(
      idForm: json['idForm'] ?? 0, 
      name: json['name'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idForm': idForm, 
      'name': name
    };
  }

  @override
  String toString() {
    return 'Formulario(idForm: $idForm, name: $name)';
  }
}
