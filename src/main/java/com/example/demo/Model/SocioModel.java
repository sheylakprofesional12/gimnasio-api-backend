package com.example.demo.Model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SocioModel {

    private Long id;

    private String dni;

    private String nombre;

    private String apellido;

    private boolean activo;

    private String telefono;

    private String correo;

    private Date fechaCreacion;
}
