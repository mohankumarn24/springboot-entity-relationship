package net.projectsync.entityrelationship.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AddressDTO {
    private Long id;
    private Long version;
    private String houseName;
    private String streetNo;
    private String city;
    private String state;
    private String country;
}
