package net.projectsync.entityrelationship.dto;

import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StudentUpdateDTO {
    // path variable carries the id
    private Long version;            // required for PUT, optional for PATCH
    private String firstName;
    private String lastName;
    private String email;
    private AddressDTO address;
    private List<PhoneDTO> phones;
    private List<ProjectDTO> projects;
}
