package net.projectsync.entityrelationship.dto;

import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StudentCreateDTO {
    private String firstName;
    private String lastName;
    private String email;
    private AddressDTO address;
    private List<PhoneDTO> phones;
    private List<ProjectDTO> projects;
}
