package com.formulario.dinamico.formulario_dinamico_back.dtos;

public class TblArchivoDTOResultado extends TblArchivoDTO {

    public TblArchivoDTOResultado(Long idArchivo, String nombreArchivo, String archivo) {
        super();
        this.setIdArchivo(idArchivo);
        this.setNombreArchivo(nombreArchivo);
        this.setArchivo(archivo);
    }
}
