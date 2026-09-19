package com.example.demo.config;

import com.example.demo.entity.RolUsuario;
import com.example.demo.entity.SocioEntity;
import com.example.demo.entity.UsuarioEntity;
import com.example.demo.repository.SocioRepository;
import com.example.demo.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private SocioRepository socioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        if (usuarioRepository.count() > 0) {
            return;
        }

        UsuarioEntity admin = UsuarioEntity.builder()
                .username("admin")
                .password(passwordEncoder.encode("123456"))
                .rol(RolUsuario.ADMIN)
                .activo(true)
                .fechaCreacion(new Date())
                .build();

        UsuarioEntity empleado = UsuarioEntity.builder()
                .username("empleado")
                .password(passwordEncoder.encode("123456"))
                .rol(RolUsuario.EMPLEADO)
                .activo(true)
                .fechaCreacion(new Date())
                .build();

        admin = usuarioRepository.save(admin);
        empleado = usuarioRepository.save(empleado);

        if (socioRepository.count() == 0) {
            socioRepository.save(SocioEntity.builder()
                    .dni("12345678")
                    .nombre("Juan")
                    .apellido("Perez")
                    .activo(true)
                    .telefono("999111222")
                    .correo("juan.perez@mail.com")
                    .fechaCreacion(new Date())
                    .usuario(admin)
                    .build());

            socioRepository.save(SocioEntity.builder()
                    .dni("87654321")
                    .nombre("Maria")
                    .apellido("Lopez")
                    .activo(false)
                    .telefono("977888999")
                    .correo("maria.lopez@mail.com")
                    .fechaCreacion(new Date())
                    .usuario(empleado)
                    .build());
        }
    }
}