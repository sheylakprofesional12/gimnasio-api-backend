package com.example.demo.Model;

import com.example.demo.dto.CreateSocioRequest;
import com.example.demo.dto.UpdateSocioRequest;
import com.example.demo.entity.SocioEntity;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

import java.util.List;

@Mapper(componentModel = "spring")
public interface SocioMapping {

    SocioModel convert(SocioEntity entidad);

    SocioEntity convert(SocioModel modelo);

    List<SocioModel> convert(List<SocioEntity> listaSocioEntidad);

    SocioEntity copy(@MappingTarget SocioEntity oldSocio, SocioModel model);

    SocioModel convert(CreateSocioRequest createSocioRequest);

    SocioModel convert(UpdateSocioRequest updateSocioRequest);

}
