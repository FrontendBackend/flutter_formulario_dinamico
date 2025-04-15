package com.formulario.dinamico.formulario_dinamico_back.utils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import io.micrometer.common.util.StringUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class FechasUtil {
    
    public static String convertDateToString(Date fecha, String formato) {
        SimpleDateFormat formatoDelTexto = new SimpleDateFormat(formato);
        String fechaString = "";
        try {

            if (fecha == null) {
                return "";
            }
            fechaString = formatoDelTexto.format(fecha);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
        return fechaString;
    }

    public static Date convertStringToDate(String fecha, String formato) {
        SimpleDateFormat format = new SimpleDateFormat(formato);
        try {
            if (StringUtils.isBlank(fecha)) {
                return null;
            }
            return format.parse(fecha);
        } catch (ParseException e) {
            log.error(e.getMessage(), e);
        }
        return null;
    }

    public static Date getToDay() {
        DateFormat format = new SimpleDateFormat("dd/MM/yyyy");
        Calendar cal = Calendar.getInstance();
        format.setCalendar(cal);
        return cal.getTime();
    }

    public static Date getToFullDay() {
        DateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        Calendar cal = Calendar.getInstance();
        format.setCalendar(cal);
        return cal.getTime();
    }
}
