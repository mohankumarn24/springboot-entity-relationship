package net.projectsync.entityrelationship.model;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Version;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String firstName;
    private String lastName;
    private String email;

    @Version
    private Long version;

    // -------- OneToOne (Student is owning side) --------
    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "address_id")						// Owning side = entity that has @JoinColumn
    private Address address;

    // -------- OneToMany (Phone owns FK) --------
    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY, mappedBy = "student", orphanRemoval = true)
    private List<Phone> phones = new ArrayList<>();

    // -------- ManyToMany (Student is owning side) --------
    @ManyToMany(cascade = { CascadeType.PERSIST, CascadeType.MERGE }, fetch = FetchType.LAZY)
    @JoinTable(name = "students_projects",
    	joinColumns = @JoinColumn(name = "student_id"),
        inverseJoinColumns = @JoinColumn(name = "project_id"))
    private List<Project> projects = new ArrayList<>();
    // private Set<Project> projects = new HashSet<>();		// Use Set for ManyToMany (Because you use List, duplicates are possible)
    
    /* OneToMany helper - (mandatory) */
    public void addPhone(Phone phone) {
        phones.add(phone);
        phone.setStudent(this);
    }

    public void removePhone(Phone phone) {
        phones.remove(phone);
        phone.setStudent(null);
    }

    /* ManyToMany helper (optional but recommended) */
    public void addProject(Project project) {
        projects.add(project);
        project.getStudents().add(this);
    }

    public void removeProject(Project project) {
        projects.remove(project);
        project.getStudents().remove(this);
    }
}

/*
 * MANY-TO-MANY NOTES
 *
 * - Relationship is stored in a JOIN TABLE
 *   (e.g. student_project with student_id, project_id)
 *
 * - NO foreign key exists in either entity table
 * - Only the OWNING side controls insert/update of join table rows
 *
 * IMPORTANT:
 * - Setting the owning side is sufficient:
 *     student.getProjects().add(project)
 *
 * - Setting the inverse side is OPTIONAL and NOT required for persistence
 *     project.getStudents().add(student)  // optional
 *
 * WHY:
 * - Hibernate persists the link using the join table
 * - No FK constraint exists in Project or Student table
 * - DB persistence works by setting the owning side alone
 *
 * NOTE:
 * - Syncing both sides is recommended only for in-memory consistency
 *   when navigating the relationship in the same transaction
 *   
 * When you SHOULD sync both sides?
 *  - Access project.getStudents() in the same transaction
 *  - Use bidirectional navigation heavily
 *  - Want in-memory consistency
 */

/*
 * BEST PRACTICE:
 * - Use helper methods to keep both sides in sync (optional)
 *
 * Example:
 *   student.addProject(project);
 *   -> adds project to student				// s.getProjects().forEach(p -> p.getStudents().add(s));
 *   -> adds student to project				// p.getStudents().forEach(s -> s.getProject().add(p));
 *
 * This avoids stale in-memory state but is NOT required for DB persistence
 */
