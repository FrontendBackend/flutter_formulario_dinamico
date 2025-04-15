package com.formulario.dinamico.formulario_dinamico_back.models.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.formulario.dinamico.formulario_dinamico_back.models.entity.TblFormulario;

@Repository
public interface FormularioRepository extends JpaRepository<TblFormulario, Long> {
    
}
