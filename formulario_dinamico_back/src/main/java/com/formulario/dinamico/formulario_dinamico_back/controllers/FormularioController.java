package com.formulario.dinamico.formulario_dinamico_back.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.formulario.dinamico.formulario_dinamico_back.models.entity.TblFormulario;
import com.formulario.dinamico.formulario_dinamico_back.services.FormularioService;

@RestController
@RequestMapping("/api/formularios")
public class FormularioController {
    
    @Autowired
    private FormularioService formularioService;

    @GetMapping("/listarFormulario")
    public List<TblFormulario> listarFormulario() {
        return this.formularioService.listarFormulario();
    }
}
