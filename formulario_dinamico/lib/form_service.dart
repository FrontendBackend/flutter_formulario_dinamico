import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:formulario_dinamico/formFieldModel.dart';

class FormService {
  Future<List<FormFieldModel>> loadFormFields() async {
    final jsonStr = await rootBundle.loadString('assets/form_config.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    print("jsonList: $jsonList");
    return jsonList.map((e) => FormFieldModel.fromJson(e)).toList();
  }
}
