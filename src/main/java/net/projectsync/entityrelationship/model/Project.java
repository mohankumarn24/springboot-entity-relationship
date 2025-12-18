package net.projectsync.entityrelationship.model;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.Version;
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

	@JsonIgnore												// @JsonIgnore is added for JSON serialization safety
	@ManyToMany(mappedBy = "projects")
	private List<Student> students = new ArrayList<>();
	// private Set<Student> students = new HashSet<>();		// Use Set for ManyToMany (Because you use List, duplicates are possible)

	@Version
	private Long version;
}

/*
 * MANY-TO-ONE / ONE-TO-MANY NOTES
 *
 * - Foreign Key (FK) is stored in the CHILD table (e.g. phones.student_id)
 * - Child entity is the OWNING side of the relationship
 *
 * IMPORTANT:
 * - We MUST set the parent on the child entity
 *   e.g. phone.setStudent(student)
 *
 * WHY:
 * - If FK is NOT NULL and we don't set it,
 *   Hibernate will try to insert NULL -> constraint violation
 *
 * RULE:
 * - Adding child to parent collection alone is NOT enough
 * - Always set both:
 *     parent.getChildren().add(child)
 *     child.setParent(parent)
 *
 * This ensures:
 * - FK is populated correctly
 * - No orphan records
 * - DB constraints are satisfied
 */
