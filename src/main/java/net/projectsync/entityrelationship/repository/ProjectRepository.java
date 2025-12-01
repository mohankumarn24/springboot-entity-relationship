package net.projectsync.entityrelationship.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import net.projectsync.entityrelationship.model.Project;

public interface ProjectRepository extends JpaRepository<Project, Long> {

    // --------------------------------------------
    // 7) All projects for a student
    // Intention: Only mapped projects
    // Correct Join: INNER JOIN
	// JPQL: PROJECT  ←→  STUDENT
	// SQL : PROJECT ←→ STUDENTS_PROJECTS ←→ STUDENT
	// 1 JPQL join = multiple SQL joins if relationships use join tables
    // --------------------------------------------
	@Query("SELECT p FROM Project p INNER JOIN p.students s WHERE s.id = :id")
	List<Project> findByStudent(@Param("id") Long id);


    // --------------------------------------------
    // 8) Projects without any student
    // Intention: Unassigned projects
    // Correct Join: LEFT JOIN + NULL
    // --------------------------------------------
	@Query("SELECT p FROM Project p LEFT JOIN p.students s WHERE s IS NULL")
	List<Project> withoutStudents();


    // --------------------------------------------
    // 9) Projects with students
    // Intention: Active projects only
    // Correct Join: INNER JOIN
    // --------------------------------------------
	@Query("SELECT DISTINCT p FROM Project p INNER JOIN p.students s")
	List<Project> withStudents();
}
