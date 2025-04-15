package com.formulario.dinamico.formulario_dinamico_back.models.entity;

import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@Table(name = "TBL_FORMULARIO")
@NoArgsConstructor
public class TblFormulario implements Serializable{

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID_FORMULARIO", nullable = false)
    private Long idFormulario;

    @Column(name = "TIPO", nullable = false)
    private String tipo;

    @Column(name = "NOMBRE", nullable = true)
    private String nombre;

    @Column(name = "LABEL", nullable = false)
    private String label;

    @Column(name = "REQUIRED", nullable = false)
    private Boolean required = false;

    // Usamos un arreglo para campos con opciones, como dropdowns
    @Column(name = "OPCION", columnDefinition = "text[]", nullable = true)
    private String[] opcion;

    // Solo se usan para sliders
    @Column(name = "MIN", nullable = true)
    private Integer min;

    @Column(name = "MAX", nullable = true)
    private Integer max;

    @Column(name = "DIVISION", nullable = true)
    private Integer divisions;

    @Column(name = "INITIAL_VALUE", nullable = true)
    private Integer initialValue;

    // Solo para botones (submit, reset)
    @Column(name = "ACTION", nullable = true)
    private String action;

    @Column(name = "CAMPO_ORDEN", nullable = true)
    private Integer campoOrden;
}