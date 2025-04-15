import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formulario_dinamico/formFieldModel.dart';
import 'package:formulario_dinamico/form_service.dart';

class DynamicFormPage extends StatefulWidget {
  const DynamicFormPage({Key? key}) : super(key: key);

  @override
  State<DynamicFormPage> createState() => _DynamicFormPageState();
}

class _DynamicFormPageState extends State<DynamicFormPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<FormFieldModel> _fields = [];

  @override
  void initState() {
    super.initState();
    _loadForm();
  }

  Future<void> _loadForm() async {
    final service = FormService();
    final fields = await service.loadFormFields();
    setState(() {
      _fields = fields;
    });
  }

  

  List<Widget> _buildFields() {
    return _fields.map((field) {
      final List<FormFieldValidator<String>> validators = [
        if (field.validators.contains('required'))
          FormBuilderValidators.required(),
        if (field.validators.contains('email')) 
          FormBuilderValidators.email(),
        if (field.validators.contains('numeric') || field.name.toLowerCase() == 'edad')
          FormBuilderValidators.numeric(),
      ];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: FormBuilderTextField(
          name: field.name,
          decoration: InputDecoration(labelText: field.label),
          validator: FormBuilderValidators.compose(validators),
          keyboardType: field.name.toLowerCase() == 'edad' ? TextInputType.number : TextInputType.text,
        ),
      );
    }).toList();
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState!.value;
      print('Formulario válido: $data');
      // Aquí puedes guardar a la base de datos
    } else {
      print('Formulario inválido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario dinámico')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _fields.isEmpty
                ? Center(child: CircularProgressIndicator())
                : FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      ..._buildFields(),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Guardar'),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
