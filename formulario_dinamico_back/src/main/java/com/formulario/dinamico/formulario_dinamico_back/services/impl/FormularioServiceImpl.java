package com.formulario.dinamico.formulario_dinamico_back.services.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.formulario.dinamico.formulario_dinamico_back.models.entity.TblFormulario;
import com.formulario.dinamico.formulario_dinamico_back.models.repository.FormularioRepository;
import com.formulario.dinamico.formulario_dinamico_back.services.FormularioService;

@Service
@Transactional(readOnly = true)
public class FormularioServiceImpl implements FormularioService{

    @Autowired
    private FormularioRepository formularioRepository;

    @Override
    public List<TblFormulario> listarFormulario() {
        return this.formularioRepository.findAll();
    }
    
}
