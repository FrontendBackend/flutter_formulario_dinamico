package com.formulario.dinamico.formulario_dinamico_back.dtos;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class TblArchivoDTO {
    
    private Long idArchivo;

    private String nombreArchivo;

    private String archivo;
}
