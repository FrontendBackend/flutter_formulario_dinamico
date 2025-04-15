class FormFieldModel {
  final String name;
  final String type;
  final String label;
  final List<String> validators;

  FormFieldModel({
    required this.name,
    required this.type,
    required this.label,
    required this.validators,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      name: json['name'],
      type: json['type'],
      label: json['label'],
      validators: List<String>.from(json['validators'] ?? []),
    );
  }
}
