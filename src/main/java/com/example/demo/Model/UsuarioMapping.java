package com.example.demo.Model;

import com.example.demo.dto.RegistrarUsuarioRequest;
import com.example.demo.entity.UsuarioEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UsuarioMapping {

    UsuarioEntity convert(RegistrarUsuarioRequest registrarUsuarioRequest);
}