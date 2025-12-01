package net.projectsync.entityrelationship.model;

import java.util.List;
import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class Project {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String projectName;

    @JsonIgnore
    @ManyToMany(mappedBy = "projects")
    private List<Student> students;

    @Version
    private Long version;
}
