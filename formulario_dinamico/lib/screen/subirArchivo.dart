// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:formulario_dinamico/enums/tipoResultado.dart';
import 'package:formulario_dinamico/models/tblArchivoDTO.dart';
import 'package:formulario_dinamico/services/formService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class SubirArchivo extends StatefulWidget {
  const SubirArchivo({super.key});

  @override
  State<SubirArchivo> createState() => _SubirArchivoState();
}

class _SubirArchivoState extends State<SubirArchivo> {
  final formularioService = FormService();
  final _formKey = GlobalKey<FormState>();
  String? nombre;
  int? edad;
  File? archivo;
  String? archivoBase64;
  Uint8List? imagenBytes; // Agrega esto como variable de estado
  String? nombreArchivo; // también agrégala como variable de estado
  List<TblArchivoDTO> listaArchivos = [];
  bool isSubiendo = false;
  bool isCargandoLista = false;

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
        isSubiendo = true; // <-- Activamos el loader
      });

      final respuesta = await formularioService.enviarArchivo(
        TblArchivoDTO(nombreArchivo: nombreArchivo, archivo: archivoBase64),
      );

      if (respuesta.tipoResultado == TipoResultado.success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Archivo enviado correctamente')));

        setState(() {
          imagenBytes = null;
          archivoBase64 = null;
          nombreArchivo = null;
          _formKey.currentState!.reset();
          isSubiendo = false; // <-- Desactivamos el loader
        });

        mostrarArchivos();
      } else {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al enviar archivo')));
        throw Exception('Error al enviar archivo: ${respuesta.mensaje}');
      }
    }
  }

  Future<void> mostrarArchivos() async {
    setState(() {
      isCargandoLista = true; // Empieza a cargar
    });

    final respuesta = await formularioService.mostrarArchivos();
    if (respuesta.tipoResultado == TipoResultado.success) {
      final lstFormDTO = List<TblArchivoDTO>.from((respuesta.lista as List).map((model) => TblArchivoDTO.fromJson(model)));
      setState(() {
        listaArchivos = lstFormDTO;
        isCargandoLista = false; // Terminó de cargar
      });
    } else {
      throw Exception('Error al mostrar archivos: ${respuesta.mensaje}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulario')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSubiendo) LinearProgressIndicator(),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // buildNombreField(),
                  SizedBox(height: 10),
                  buildBotonesArchivo(),
                  buildVistaPreviaArchivo(),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: isSubiendo ? null : enviarDatos,
                    child: isSubiendo
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : Text('Enviar'),
                  ),

                  SizedBox(height: 30),

                  Text(
                    'Imágenes subidas:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  buildGridImagenes(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Campo de texto para el nombre
  // Widget buildNombreField() {
  //   return TextFormField(
  //     decoration: InputDecoration(labelText: 'Nombre'),
  //     onChanged: (value) => (nombre = value, _formKey.currentState!.validate()),
  //     validator: (value) => value!.isEmpty ? 'Requerido' : null,
  //   );
  // }

  // Botones de seleccionar y tomar foto
  Widget buildBotonesArchivo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: seleccionarArchivo,
            child: Text('Seleccionar archivo'),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: tomarFoto,
            child: Text('Tomar foto'),
          ),
        ),
      ],
    );
  }

  // Vista previa del archivo seleccionado
  Widget buildVistaPreviaArchivo() {
    if (imagenBytes != null) {
      return Column(
        children: [
          SizedBox(height: 10),
          Text('Archivo seleccionado: $nombreArchivo'),
          SizedBox(height: 10),
          nombreArchivo!.toLowerCase().endsWith('.pdf')
              ? Icon(Icons.picture_as_pdf, size: 100, color: Colors.red)
              : Image.memory(
                imagenBytes!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
        ],
      );
    } else {
      return Text('Ningún archivo seleccionado');
    }
  }

  // Lista de imágenes subidas
  Widget buildGridImagenes() {
    if (isCargandoLista) {
      return LinearProgressIndicator();
    } else if (listaArchivos.isEmpty) {
      return Text('No hay archivos subidos aún.');
    } else {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children:
            listaArchivos.map((item) {
              final nombreArchivo = item.nombreArchivo ?? '';
              final archivoBase64 = item.archivo;
              final esPDF = nombreArchivo.toLowerCase().endsWith('.pdf');

              Widget vistaPrevia;
              if (esPDF) {
                vistaPrevia = Icon(
                  Icons.picture_as_pdf,
                  size: 80,
                  color: Colors.red,
                );
              } else {
                try {
                  final bytes = base64Decode(archivoBase64!);
                  vistaPrevia = Image.memory(
                    bytes,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Text('Error al mostrar imagen'),
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
      );
    }
  }

}
