package net.projectsync.entityrelationship.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProjectDTO {
    private Long id;
    private Long version;
    private String projectName;
}
