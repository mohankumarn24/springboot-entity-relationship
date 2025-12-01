package net.projectsync.entityrelationship.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PhoneDTO {
    private Long id;
    private Long version;
    private String phoneModel;
    private String phoneNumber;
}
