package com.formulario.dinamico.formulario_dinamico_back.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.formulario.dinamico.formulario_dinamico_back.dtos.ResponseDTO;
import com.formulario.dinamico.formulario_dinamico_back.dtos.TblArchivoDTO;
import com.formulario.dinamico.formulario_dinamico_back.exception.PgimException.TipoResultado;
import com.formulario.dinamico.formulario_dinamico_back.models.entity.TblFormulario;
import com.formulario.dinamico.formulario_dinamico_back.services.ArchivoService;
import com.formulario.dinamico.formulario_dinamico_back.services.FormularioService;

import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/api/formularios")
public class FormularioController {

    @Autowired
    private FormularioService formularioService;

    @Autowired
    private ArchivoService archivoService;

    @GetMapping("/listarFormulario")
    public List<TblFormulario> listarFormulario() {
        return this.formularioService.listarFormulario();
    }

    @PostMapping("/crearArchivo")
    public ResponseEntity<ResponseDTO> crearArchivo(@Valid @RequestBody TblArchivoDTO tblArchivoDTO,
            BindingResult resultadoValidacion) throws Exception {

        TblArchivoDTO tblArchivoDTOCreado = null;

        if (resultadoValidacion.hasErrors()) {
            List<String> errores = null;
            errores = resultadoValidacion.getFieldErrors().stream().map(err -> String.format("La propiedad '%s' %s", err.getField(), err.getDefaultMessage())).collect(Collectors.toList());
            log.error(errores.toString());
            return ResponseEntity.status(HttpStatus.OK).body(new ResponseDTO(TipoResultado.ERROR, errores.toString()));
        }

        try {
            tblArchivoDTOCreado = this.archivoService.crearArchivo(tblArchivoDTO);
        } catch (DataAccessException e) {
            log.error(e.getMostSpecificCause().getMessage(), e);
            
            return ResponseEntity.status(HttpStatus.OK).body(new ResponseDTO(TipoResultado.ERROR, "Ocurrió un error al intentar subir el archivo"));
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.OK).body(new ResponseDTO(TipoResultado.ERROR, String.format("Ocurrió un error al intentar subir el archivo. Mensaje de la excepción: %s", e.getMessage())));
        }

        return ResponseEntity.status(HttpStatus.CREATED).body(new ResponseDTO(TipoResultado.SUCCESS, tblArchivoDTOCreado, "Archivo subido con exito"));
    }

    @GetMapping("/mostrarArchivos")
    public ResponseEntity<ResponseDTO> mostrarArchivos() {

        List<TblArchivoDTO> lTblArchivoDTO = new ArrayList<>();

        try {
            lTblArchivoDTO = archivoService.mostrarArchivos();
        } catch (Exception e) {
            String mensaje = "Ocurrió un error al mostrar los archivos";
            log.error(mensaje + ": " + e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.OK).body(new ResponseDTO(TipoResultado.ERROR, mensaje));
        }
        return ResponseEntity.status(HttpStatus.OK).body(new ResponseDTO(TipoResultado.SUCCESS, lTblArchivoDTO, "Se muestran los archivos exitosamente"));
    }
}
