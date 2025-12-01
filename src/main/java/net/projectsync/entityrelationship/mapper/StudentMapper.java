package net.projectsync.entityrelationship.mapper;

import java.util.List;
import java.util.stream.Collectors;

import net.projectsync.entityrelationship.dto.*;
import net.projectsync.entityrelationship.model.*;

public class StudentMapper {

    private StudentMapper() {}

    // =========================================
    // ENTITY → DTO
    // =========================================
    public static StudentDTO toDTO(Student s) {

        if (s == null) return null;

        StudentDTO dto = new StudentDTO();
        dto.setId(s.getId());
        dto.setVersion(s.getVersion());
        dto.setFirstName(s.getFirstName());
        dto.setLastName(s.getLastName());
        dto.setEmail(s.getEmail());

        if (s.getAddress() != null)
            dto.setAddress(toDTO(s.getAddress()));

        if (s.getPhones() != null)
            dto.setPhones(
                    s.getPhones().stream()
                            .map(StudentMapper::toDTO)
                            .collect(Collectors.toList())
            );

        if (s.getProjects() != null)
            dto.setProjects(
                    s.getProjects().stream()
                            .map(StudentMapper::toProjectDTO)
                            .collect(Collectors.toList())
            );

        return dto;
    }

    private static AddressDTO toDTO(Address a) {
        AddressDTO dto = new AddressDTO();
        dto.setId(a.getId());
        dto.setVersion(a.getVersion());
        dto.setHouseName(a.getHouseName());
        dto.setStreetNo(a.getStreetNo());
        dto.setCity(a.getCity());
        dto.setState(a.getState());
        dto.setCountry(a.getCountry());
        return dto;
    }

    private static PhoneDTO toDTO(Phone p) {
        PhoneDTO dto = new PhoneDTO();
        dto.setId(p.getId());
        dto.setVersion(p.getVersion());
        dto.setPhoneModel(p.getPhoneModel());
        dto.setPhoneNumber(p.getPhoneNumber());
        return dto;
    }

    public static ProjectDTO toProjectDTO(Project p) {
        ProjectDTO dto = new ProjectDTO();
        dto.setId(p.getId());
        dto.setVersion(p.getVersion());
        dto.setProjectName(p.getProjectName());
        return dto;
    }

    // =========================================
    // CREATE DTO → NEW ENTITY
    // =========================================
    public static Student toNewEntity(StudentCreateDTO dto) {

        Student s = new Student();
        s.setFirstName(dto.getFirstName());
        s.setLastName(dto.getLastName());
        s.setEmail(dto.getEmail());

        if (dto.getAddress() != null)
            s.setAddress(toNewAddress(dto.getAddress()));

        if (dto.getPhones() != null) {
            List<Phone> phones = dto.getPhones().stream()
                    .map(StudentMapper::toNewPhone)
                    .collect(Collectors.toList());
            phones.forEach(p -> p.setStudent(s));
            s.getPhones().addAll(phones);
        }

        // projects are handled in service (because of shared entities & version)
        return s;
    }

    private static Address toNewAddress(AddressDTO dto) {
        Address a = new Address();
        a.setHouseName(dto.getHouseName());
        a.setStreetNo(dto.getStreetNo());
        a.setCity(dto.getCity());
        a.setState(dto.getState());
        a.setCountry(dto.getCountry());
        return a;
    }

    private static Phone toNewPhone(PhoneDTO dto) {
        Phone p = new Phone();
        p.setPhoneModel(dto.getPhoneModel());
        p.setPhoneNumber(dto.getPhoneNumber());
        return p;
    }

    // =========================================
    // BASIC FIELD UPDATES (Student only)
    // =========================================
    public static void applyPutOnStudentBasic(Student s, StudentUpdateDTO dto) {
        s.setFirstName(dto.getFirstName());
        s.setLastName(dto.getLastName());
        s.setEmail(dto.getEmail());
    }

    public static void applyPatchOnStudentBasic(Student s, StudentUpdateDTO dto) {
        if (dto.getFirstName() != null) s.setFirstName(dto.getFirstName());
        if (dto.getLastName() != null)  s.setLastName(dto.getLastName());
        if (dto.getEmail() != null)     s.setEmail(dto.getEmail());
    }
}
