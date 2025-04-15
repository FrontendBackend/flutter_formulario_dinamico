import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;

class FormBuilderDynamic extends StatefulWidget {
  const FormBuilderDynamic({super.key});

  @override
  State<FormBuilderDynamic> createState() => _FormBuilderDynamicState();
}

class _FormBuilderDynamicState extends State<FormBuilderDynamic> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<dynamic> fields = [];
  
  @override
  void initState() {
    super.initState();
    loadJsonConfig();
  }

  Future<void> loadJsonConfig() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8082/appformulario/api/formularios/listarFormulario'));
    //// final String jsonString = await rootBundle.loadString('assets/form.json');

    setState(() {
      final body = utf8.decode(response.bodyBytes);
      fields = json.decode(body);
      fields.sort((asc, desc) => asc['campoOrden'].compareTo(desc['campoOrden']));
    });
  }

  Widget _buildField(Map<String, dynamic> field) {
    final List<String? Function(dynamic)> validators = [];

    // Validación común de campos obligatorios
    if (field['required'] == true) {
      validators.add((value) {
        if (value == null || value.toString().isEmpty) {
          return 'Campo obligatorio';
        }
        return null;
      });
    }

    switch (field['tipo']) {
      case 'text':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormBuilderTextField(
              name: field['nombre'],
              decoration: InputDecoration(labelText: field['label'], border: OutlineInputBorder()),
              validator: FormBuilderValidators.compose(validators),
            ),
            SizedBox(height: 20), 
          ],
        );

      case 'email':
        validators.add((value) {
          if (value == null || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value)) {
            return 'Correo inválido';
          }
          return null;
        });
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormBuilderTextField(
              name: field['nombre'],
              decoration: InputDecoration(labelText: field['label'], border: OutlineInputBorder()),
              validator: FormBuilderValidators.compose(validators),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20), 
          ],
        ); 
        
      case 'number':
        validators.add(FormBuilderValidators.numeric(errorText: 'Debe ser un número válido'));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormBuilderTextField(
              name: field['nombre'],
              decoration: InputDecoration(labelText: field['label'], border: OutlineInputBorder()),
              validator: FormBuilderValidators.compose(validators),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20), 
          ],
        );

      case 'dropdown':
        // Asegurarse de que field['options'] sea una lista de cadenas
        List<String> options = [];
        if (field['opcion'] is List<dynamic>) {
          options = List<String>.from(field['opcion']);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormBuilderDropdown(
              name: field['nombre'],
              decoration: InputDecoration(labelText: field['label'], border: OutlineInputBorder()),
              validator: FormBuilderValidators.compose(validators),
              items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
            ),
            SizedBox(height: 20), 
          ],
        );

      case 'date':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormBuilderDateTimePicker(
              name: field['nombre'],
              decoration: InputDecoration(labelText: field['label'], border: OutlineInputBorder()),
              validator: (value) {
                if (field['required'] == true && value == null) {
                  return 'Fecha requerida';
                }
                return null;
              },
              inputType: InputType.date,
            ),
            SizedBox(height: 10), 
          ],
        );

      case 'checkbox':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormBuilderCheckbox(
              name: field['nombre'],
              title: Text(field['label']),
              validator: field['required'] == true ? (value) => value == true ? null : 'Debes aceptar los términos' : null,
            ),
            SizedBox(height: 10),
          ],
        );

      case 'slider':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormBuilderSlider(
              name: field['nombre'],
              decoration: InputDecoration(labelText: field['label']),
              min: field['min'].toDouble(),
              max: field['max'].toDouble(),
              initialValue: field['initialValue'].toDouble(),
              divisions: field['divisions'],
              validator: (value) {
                if (value == null || value < field['min'] || value > field['max']) {
                  return 'Valor fuera de rango';
                }
                return null;
              },
            ),
            SizedBox(height: 10), 
          ],
        );

      case 'button':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                if (field['action'] == 'submit') {
                  _submit();
                } else if (field['action'] == 'reset') {
                  _formKey.currentState?.reset();
                } else {
                  print('Acción no reconocida: ${field['action']}');
                }
              },
              child: Text(field['label'] ?? 'Botón'),
            ),
            SizedBox(height: 10),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void _submit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState?.value;
      print('Datos enviados: $values');
      // Aquí podrías enviar los datos a una API, guardar en BD, etc.
    } else {
      print('Formulario inválido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario Dinámico'),
      centerTitle: true,
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: true, 
      body:
          fields.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                // Agregar SingleChildScrollView
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [ ...fields.map((field) => _buildField(field)),
                        const SizedBox(
                          height: 20,
                        ), // Espaciado adicional si es necesario
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
