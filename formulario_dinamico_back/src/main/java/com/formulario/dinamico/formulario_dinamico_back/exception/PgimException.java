package com.formulario.dinamico.formulario_dinamico_back.exception;

import org.springframework.http.HttpStatus;

import org.springframework.web.bind.annotation.ResponseStatus;

import com.formulario.dinamico.formulario_dinamico_back.dtos.DetalleExcepcionDTO;

@ResponseStatus(HttpStatus.NOT_IMPLEMENTED)
public class PgimException extends RuntimeException{
    
    private static final long serialVersionUID = 7422398171133598173L;

    private String mensaje;

    private Number valor;

    private String tipoResultadoCadena;

    private TipoResultado tipoResultado = TipoResultado.NONE;

    private DetalleExcepcionDTO detalleExcepcionDTO;

    public PgimException(String tipoResultadoCadena, String mensaje) {
        super(mensaje);
        this.mensaje = mensaje;

        if (tipoResultadoCadena.equals(TipoResultado.SUCCESS.getValor())) {
            this.tipoResultadoCadena = TipoResultado.SUCCESS.getValor();

        } else if (tipoResultadoCadena.equals(TipoResultado.ERROR.getValor())) {
            this.tipoResultadoCadena = TipoResultado.ERROR.getValor();

        } else if (tipoResultadoCadena.equals(TipoResultado.WARNING.getValor())) {
            this.tipoResultadoCadena = TipoResultado.WARNING.getValor();

        } else if (tipoResultadoCadena.equals(TipoResultado.INFO.getValor())) {
            this.tipoResultadoCadena = TipoResultado.INFO.getValor();
        }
    }

    public PgimException(TipoResultado tipoResultado, String mensaje) {
        super(mensaje);

        this.tipoResultado = tipoResultado;
        this.mensaje = mensaje;
    }

    public PgimException(TipoResultado tipoResultado, String mensaje, Number valor) {
        super(mensaje);

        this.tipoResultado = tipoResultado;
        this.mensaje = mensaje;
        this.valor = valor;
    }

    public PgimException(TipoResultado tipoResultado, String mensaje, DetalleExcepcionDTO detalleExcepcionDTO) {
        super(mensaje);

        this.tipoResultado = tipoResultado;
        this.mensaje = mensaje;
        this.detalleExcepcionDTO = detalleExcepcionDTO;
    }

    public PgimException(String mensaje) {
        super(mensaje);
        this.mensaje = mensaje;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public Number getValor() {
        return valor;
    }

    public void setValor(Number valor) {
        this.valor = valor;
    }

    public String getTipoResultadoCadena() {
        return tipoResultadoCadena;
    }

    public TipoResultado getTipoResultado() {
        return tipoResultado;
    }

    public void setTipoResultado(TipoResultado tipoExcepcion) {
        this.tipoResultado = tipoExcepcion;
    }

    public DetalleExcepcionDTO getDetalleExcepcionDTO() {
        return detalleExcepcionDTO;
    }

    public void setDetalleExcepcionDTO(DetalleExcepcionDTO detalleExcepcionDTO) {
        this.detalleExcepcionDTO = detalleExcepcionDTO;
    }

    public enum TipoResultado {

        NONE("NONE"),
        INFO("INFO"),
        ERROR("ERROR"),
        WARNING("WARNING"),
        SUCCESS("SUCCESS");

        private final String codigo;

        TipoResultado(String codigo) {
            this.codigo = codigo;
        }

        public String getValor() {
            return codigo;
        }
    }
}
