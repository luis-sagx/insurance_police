package com.example.bdd_dto.repository;

import com.example.bdd_dto.model.Propietario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface PropietarioRepository extends JpaRepository<Propietario, Long> {
    Optional<Propietario> findByNombreAndApellido(String nombre, String apellido);
    
    // Devuelve una lista ordenada por ID descendente (más reciente primero)
    List<Propietario> findByNombreAndApellidoOrderByIdDesc(String nombre, String apellido);

}
