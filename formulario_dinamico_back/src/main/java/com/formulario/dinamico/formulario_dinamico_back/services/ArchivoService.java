package com.formulario.dinamico.formulario_dinamico_back.services;

import java.util.List;

import com.formulario.dinamico.formulario_dinamico_back.dtos.TblArchivoDTO;

import jakarta.validation.Valid;

public interface ArchivoService {
    
    public TblArchivoDTO crearArchivo(@Valid TblArchivoDTO tblArchivoDTO);

    public List<TblArchivoDTO> mostrarArchivos();
}
