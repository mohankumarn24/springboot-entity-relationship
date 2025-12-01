package net.projectsync.entityrelationship.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import net.projectsync.entityrelationship.model.Project;

public interface ProjectRepository extends JpaRepository<Project, Long> {

    // --------------------------------------------
    // Find all projects for a student
	// JPQL: PROJECT  ←→  STUDENT
	// SQL : PROJECT ←→ STUDENTS_PROJECTS ←→ STUDENT
	// 1 JPQL join = multiple SQL joins if relationships use join tables
    // --------------------------------------------
	@Query("SELECT p FROM Project p INNER JOIN p.students s WHERE s.id = :id")
	List<Project> findByStudent(@Param("id") Long id);

    // --------------------------------------------
    // Find projects with students
    // Intention: Active projects only. Excludes orphan projects
    // INNER JOIN
    // --------------------------------------------
	@Query("SELECT DISTINCT p FROM Project p INNER JOIN p.students s")
	List<Project> withStudents();
	
    // --------------------------------------------
    // Find projects without any student
    // Intention: Unassigned projects. Excludes orphan projects. Detects missing foreign rows
    // LEFT JOIN + NULL
    // --------------------------------------------
	@Query("SELECT p FROM Project p LEFT JOIN p.students s WHERE s IS NULL")
	List<Project> withoutStudents();
}
