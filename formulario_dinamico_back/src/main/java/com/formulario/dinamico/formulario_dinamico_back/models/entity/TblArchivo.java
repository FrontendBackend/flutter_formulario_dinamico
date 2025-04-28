package com.formulario.dinamico.formulario_dinamico_back.models.entity;

import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@Table(name = "TBL_ARCHIVO")
@NoArgsConstructor
public class TblArchivo implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID_ARCHIVO", nullable = false)
    private Long idArchivo;

    @Column(name = "NOMBRE_ARCHIVO", nullable = true)
    private String nombreArchivo;

    @Lob
    @Column(name = "ARCHIVO", columnDefinition = "BLOB") // <= SQlite(columnDefinition = "BLOB") | posgreSQL(columnDefinition = "TEXT")
    private String archivo;
    // private byte[] archivo; // => con este tipo de datos funciona de igual manera
}
