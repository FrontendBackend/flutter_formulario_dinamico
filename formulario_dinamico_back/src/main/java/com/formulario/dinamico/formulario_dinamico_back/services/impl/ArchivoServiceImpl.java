package com.formulario.dinamico.formulario_dinamico_back.services.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.formulario.dinamico.formulario_dinamico_back.dtos.TblArchivoDTO;
import com.formulario.dinamico.formulario_dinamico_back.models.entity.TblArchivo;
import com.formulario.dinamico.formulario_dinamico_back.models.repository.ArchivoRepository;
import com.formulario.dinamico.formulario_dinamico_back.services.ArchivoService;

import jakarta.validation.Valid;

@Service
@Transactional(readOnly = true)
public class ArchivoServiceImpl implements ArchivoService {

    @Autowired
    private ArchivoRepository archivoRepository;

	@Transactional(readOnly = false)
    @Override
    public TblArchivoDTO crearArchivo(@Valid TblArchivoDTO tblArchivoDTO) {
        
        // System.out.println("Archivo recibido: " + tblArchivoDTO.getArchivo());

        TblArchivo tblArchivo = new TblArchivo();

        tblArchivo.setNombreArchivo(tblArchivoDTO.getNombreArchivo());
        tblArchivo.setArchivo(tblArchivoDTO.getArchivo());

        TblArchivo tblArchivoCreado = this.archivoRepository.save(tblArchivo);
        TblArchivoDTO tblArchivoDTOCreado = this.archivoRepository.obtenerArchivoPorId(tblArchivoCreado.getIdArchivo());

        return tblArchivoDTOCreado;
    }

    @Override
    public List<TblArchivoDTO> mostrarArchivos() {
        List<TblArchivoDTO> lTblArchivoDTO = this.archivoRepository.mostrarArchivos();
        return lTblArchivoDTO;
    }
    
}
