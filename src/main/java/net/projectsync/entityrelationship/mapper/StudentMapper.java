package net.projectsync.entityrelationship.mapper;

import java.util.List;
import java.util.stream.Collectors;
import net.projectsync.entityrelationship.dto.AddressDTO;
import net.projectsync.entityrelationship.dto.PhoneDTO;
import net.projectsync.entityrelationship.dto.ProjectDTO;
import net.projectsync.entityrelationship.dto.StudentCreateDTO;
import net.projectsync.entityrelationship.dto.StudentDTO;
import net.projectsync.entityrelationship.model.Address;
import net.projectsync.entityrelationship.model.Phone;
import net.projectsync.entityrelationship.model.Project;
import net.projectsync.entityrelationship.model.Student;

public class StudentMapper {

    private StudentMapper() {}

    // =========================================
    // CREATE DTO → NEW ENTITY
    // =========================================
    public static Student toNewEntity(StudentCreateDTO dto) {

        Student s = new Student();
        s.setFirstName(dto.getFirstName());
        s.setLastName(dto.getLastName());
        s.setEmail(dto.getEmail());

        // OneToOne
        if (dto.getAddress() != null) {
        	s.setAddress(toNewAddress(dto.getAddress()));
        }

        // OneToMany
        if (dto.getPhones() != null) {
            List<Phone> phones = dto.getPhones().stream()
                    .map(StudentMapper::toNewPhone)
                    .collect(Collectors.toList());
            phones.forEach(p -> p.setStudent(s));		// To avoid setting FK=null in 'phones' table and hence avoid creating orphan records
            											// Since, FK cannot be null, it throws constraint violation
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
    // ENTITY → DTO
    // =========================================
    public static StudentDTO toDTO(Student s) {

        if (s == null) {
        	return null;
        }

        StudentDTO dto = new StudentDTO();
        dto.setId(s.getId());
        dto.setVersion(s.getVersion());
        dto.setFirstName(s.getFirstName());
        dto.setLastName(s.getLastName());
        dto.setEmail(s.getEmail());

        // OneToOne
        if (s.getAddress() != null)
            dto.setAddress(toDTO(s.getAddress()));

        // OneToMany
        if (s.getPhones() != null) {
            dto.setPhones(
                    s.getPhones().stream()
                            .map(StudentMapper::toDTO)
                            .collect(Collectors.toList())
            );
            
            /* same as above 'if' block
			List<PhoneDTO> phoneDTOList = new ArrayList<>();
			for (Phone phone : s.getPhones()) {
			    PhoneDTO phoneDTO = StudentMapper.toDTO(phone);
			    phoneDTOList.add(phoneDTO);
			}
            */
        }

        // ManyToMany
        if (s.getProjects() != null) {
            dto.setProjects(
                    s.getProjects().stream()
                            .map(StudentMapper::toProjectDTO)
                            .collect(Collectors.toList())
            );
            
            /* same as above 'if' block
		    List<ProjectDTO> projectDTOList = new ArrayList<>();
		
		    for (Project project : s.getProjects()) {
		        ProjectDTO projectDTO = StudentMapper.toProjectDTO(project);
		        projectDTOList.add(projectDTO);
		    }
            */
        }

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
}
