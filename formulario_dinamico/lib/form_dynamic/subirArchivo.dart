import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:formulario_dinamico/models/responseDTO.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:getwidget/getwidget.dart';

class SubirArchivo extends StatefulWidget {
  const SubirArchivo({super.key});

  @override
  State<SubirArchivo> createState() => _SubirArchivoState();
}

class _SubirArchivoState extends State<SubirArchivo> {
  final _formKey = GlobalKey<FormState>();
  String? nombre;
  int? edad;
  File? archivo;
  String? archivoBase64;
  Uint8List? imagenBytes; // Agrega esto como variable de estado
  String? nombreArchivo; // también agrégala como variable de estado
  List<Map<String, dynamic>> listaArchivos = [];
  double progreso = 0.0;
  bool subiendoArchivo = false;

  @override
  void initState() {
    super.initState();
    mostrarArchivos();
  }

  Future<void> seleccionarArchivo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any, // permitir ver todo
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final picked = result.files.single;
        final extension = picked.extension?.toLowerCase();

        // Verificar que solo sea PDF o imagen
        if (extension == 'jpg' ||
            extension == 'jpeg' ||
            extension == 'png' ||
            extension == 'pdf') {
          setState(() {
            imagenBytes = picked.bytes;
            archivoBase64 = base64Encode(picked.bytes!);
            nombreArchivo = picked.name;
          });
        } else {
          // Mostrar alerta si no es permitido
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Solo se permiten imágenes y archivos PDFs'),
            ),
          );
        }
      }
    } catch (e) {
      print('Error al seleccionar archivo: $e');
    }
  }

  Future<void> tomarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        imagenBytes = bytes;
        archivoBase64 = base64Encode(bytes);
        nombreArchivo = pickedFile.name;
      });
    }
  }

  Future<void> enviarDatos() async {
    if (_formKey.currentState!.validate()) {
      if (archivoBase64 == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Debes seleccionar un archivo')));
        return;
      }

      setState(() {
        subiendoArchivo = true;
        progreso = 0.0;
      });

      try {
        // Simulación de avance
        for (int i = 0; i <= 10; i++) {
          await Future.delayed(Duration(milliseconds: 100));
          setState(() {
            progreso = i / 10;
          });
        }

        final url = Uri.parse(
          'http://192.168.18.39:8082/appformulario/api/formularios/crearArchivo',
        );
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'nombreArchivo': nombre, 'archivo': archivoBase64}),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Enviado correctamente')));

          setState(() {
            imagenBytes = null;
            archivoBase64 = null;
            nombreArchivo = null;
            _formKey.currentState!.reset();
          });
          mostrarArchivos();
        } else {
          print(response.body);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error al enviar')));
        }
      } catch (e) {
        print('Error al subir archivo: $e');
      } finally {
        setState(() {
          subiendoArchivo = false;
          progreso = 0.0;
        });
      }
    }
  }

  Future<void> mostrarArchivos() async {
    final response = await http.get(
      Uri.parse(
        'http://192.168.18.39:8082/appformulario/api/formularios/mostrarArchivos',
      ),
    );

    if (response.statusCode == 200) {
      final respuesta = ResponseDTO.fromJson(
        json.decode(utf8.decode(response.bodyBytes)),
      );

      final List datos = respuesta.data;
      setState(() {
        listaArchivos = List<Map<String, dynamic>>.from(datos);
      });
    }
  }

  bool esImagen(String? nombreArchivo) {
    final ext = nombreArchivo?.toLowerCase();
    return ext != null &&
        (ext.endsWith('.jpg') || ext.endsWith('.jpeg') || ext.endsWith('.png'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulario')),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) => nombre = value,
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: seleccionarArchivo,
                      child: Text('Seleccionar archivo'),
                    ),
                  ),
                  SizedBox(width: 10), // Espacio entre botones
                  Expanded(
                    child: ElevatedButton(
                      onPressed: tomarFoto,
                      child: Text('Tomar foto'),
                    ),
                  ),
                ],
              ),
              imagenBytes != null
                  ? Column(
                    children: [
                      SizedBox(height: 10),
                      Text('Archivo seleccionado: $nombreArchivo'),
                      SizedBox(height: 10),
                      nombreArchivo!.toLowerCase().endsWith('.pdf')
                          ? Icon(
                            Icons.picture_as_pdf,
                            size: 100,
                            color: Colors.red,
                          )
                          : Image.memory(
                            imagenBytes!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                    ],
                  )
                  : Text('Ningún archivo seleccionado'),

              SizedBox(height: 20),
              ElevatedButton(onPressed: enviarDatos, child: Text('Enviar')),

              if (subiendoArchivo)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GFProgressBar(
                    percentage: progreso,
                    backgroundColor: Colors.grey.shade300,
                    progressBarColor: Colors.blue,
                    lineHeight: 10,
                    alignment: MainAxisAlignment.spaceBetween,
                    child: Text(
                      '${(progreso * 100).toStringAsFixed(0)}%',
                      textAlign: TextAlign.end, style: TextStyle(fontSize: 8),
                      
                    ),
                  ),
                ),
              SizedBox(height: 30),
              Text(
                'Imágenes subidas:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              if (listaArchivos.isEmpty) Text('No hay archivos subidos aún.'),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children:
                    listaArchivos.map((item) {
                      final nombreArchivo = item['nombreArchivo'] ?? '';
                      final archivoBase64 = item['archivo'];

                      final esPDF = nombreArchivo.toLowerCase().endsWith(
                        '.pdf',
                      );
                      Widget vistaPrevia;

                      if (esPDF) {
                        vistaPrevia = Icon(
                          Icons.picture_as_pdf,
                          size: 80,
                          color: Colors.red,
                        );
                      } else {
                        try {
                          final bytes = base64Decode(archivoBase64);
                          vistaPrevia = Image.memory(
                            bytes,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Text('Error al mostrar imagen');
                            },
                          );
                        } catch (e) {
                          vistaPrevia = Text('Archivo no válido');
                        }
                      }

                      return Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: vistaPrevia,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                nombreArchivo,
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
