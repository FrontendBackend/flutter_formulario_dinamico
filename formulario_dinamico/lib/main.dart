import 'package:flutter/material.dart';
// import 'package:formulario_dinamico/dynamic_form_page.dart';
// import 'package:formulario_dinamico/form_dynamic/form_builder_dynamic.dart';
import 'package:formulario_dinamico/form_dynamic/prueba.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        // colorSchemeSeed: Colors.blueAccent,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      // home: DynamicFormPage(), 
      home: const PruebaWidget(),
      debugShowCheckedModeBanner: false
      ),
  );
}