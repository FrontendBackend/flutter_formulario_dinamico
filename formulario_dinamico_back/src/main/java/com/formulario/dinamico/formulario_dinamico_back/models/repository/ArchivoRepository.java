package com.formulario.dinamico.formulario_dinamico_back.models.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.formulario.dinamico.formulario_dinamico_back.dtos.TblArchivoDTO;
import com.formulario.dinamico.formulario_dinamico_back.models.entity.TblArchivo;

public interface ArchivoRepository extends JpaRepository<TblArchivo, Long>{

    @Query("SELECT new com.formulario.dinamico.formulario_dinamico_back.dtos.TblArchivoDTOResultado("
			+ "ar.idArchivo, ar.nombreArchivo, ar.archivo "
            + ") "
			+ "FROM TblArchivo ar "
			)
	List<TblArchivoDTO> mostrarArchivos();

    @Query("SELECT new com.formulario.dinamico.formulario_dinamico_back.dtos.TblArchivoDTOResultado("
			+ "ar.idArchivo, ar.nombreArchivo, ar.archivo "
            + ") "
			+ "FROM TblArchivo ar "
			+ "WHERE ar.idArchivo = :idArchivo ")
	TblArchivoDTO obtenerArchivoPorId(@Param("idArchivo") Long idArchivo);
} 
