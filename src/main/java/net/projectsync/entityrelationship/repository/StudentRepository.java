package net.projectsync.entityrelationship.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import net.projectsync.entityrelationship.model.Student;

public interface StudentRepository extends JpaRepository<Student, Long> {

	// inner join -> return student ONLY if there is no address
	// left join  -> return student even if there is no address
	
    /*
     * -------------------------------------------
     * Student + Address (OneToOne)
     * -------------------------------------------
     * LEFT JOIN FETCH ensures:
     *   - Student is returned even if address is NULL
     *   - Address is LOADED eagerly in same SQL
     *   - Prevents LazyInitializationException
	*/
	@Query("SELECT s FROM Student s LEFT JOIN FETCH s.address WHERE s.id = :id")
	Optional<Student> findBase(@Param("id") Long id);

    /*
     * -------------------------------------------
     * Student + Phones (OneToMany)
     * -------------------------------------------
     * DISTINCT is REQUIRED:
     *   - Prevents duplicate student rows
     *   - One student → multiple phones
     *   - SQL returns multiple rows per student
	*/
	@Query("SELECT DISTINCT s FROM Student s LEFT JOIN FETCH s.phones WHERE s.id = :id")
	Optional<Student> fetchPhones(@Param("id") Long id);


    /*
     * -------------------------------------------
     * Student + Projects (ManyToMany)
     * -------------------------------------------
     * JOIN happens via junction table (students_projects)
     *
     * JPQL:
     *    Student ←→ Project
     *
     * SQL:
     *    Student ←→ students_projects ←→ Project
     *
     * FETCH avoids N+1 select problem:
     *   1 query instead of many
	*/
	@Query("SELECT DISTINCT s FROM Student s LEFT JOIN FETCH s.projects WHERE s.id = :id")
	Optional<Student> fetchProjects(@Param("id") Long id);

    /*
     * -------------------------------------------
     * Students BY Project Name
     * -------------------------------------------
     * INNER JOIN:
     *   - Only students linked to project are returned
     *   - Filters using projectName
	*/
	@Query("SELECT DISTINCT s FROM Student s INNER JOIN s.projects p WHERE p.projectName = :name")
	List<Student> findByProjectName(@Param("name") String name);

    /*
     * -------------------------------------------
     * Students WITH Phones
     * -------------------------------------------
     * INNER JOIN:
     *   - Removes students who have no phones
	*/
	@Query("SELECT DISTINCT s FROM Student s INNER JOIN s.phones p")
	List<Student> withPhones();

    /*
     * -------------------------------------------
     * Students WITHOUT Phones
     * -------------------------------------------
     * LEFT JOIN + NULL condition detects missing relation
	*/
	@Query("SELECT s FROM Student s LEFT JOIN s.phones p WHERE p IS NULL")
	List<Student> withoutPhones();

    /*
     * -------------------------------------------
     * Students WITH Address
     * -------------------------------------------
     * INNER JOIN:
     *   - Only students having address
	*/
	@Query("SELECT s FROM Student s INNER JOIN s.address a")
	List<Student> withAddress();

    /*
     * -------------------------------------------
     * Students WITHOUT Address
     * -------------------------------------------
     * LEFT JOIN + IS NULL pattern
	*/
	@Query("SELECT s FROM Student s LEFT JOIN s.address a WHERE a IS NULL")
	List<Student> withoutAddress();
}

/*
 * LEFT JOIN vs LEFT JOIN FETCH:
 * ----------------------------
 * LEFT JOIN
 *   → Controls which rows are returned
 *   → Does NOT load related objects into memory
 *   → May trigger LazyInitializationException if accessed later
 * 
 * LEFT JOIN FETCH
 *   → Controls BOTH:
 *      1) which rows are returned
 *      2) what objects are initialized eagerly
 *   → Loads data in a SINGLE SQL query using JOIN
 * 
 * INNER JOIN vs LEFT JOIN:
 * ------------------------ 
 * INNER JOIN
 *   → "Only return rows that have matching record"
 *   → Excludes students if relation is missing  
 * 
 * LEFT JOIN
 *   → "Give everything from left side even if no relation"
 *   → Includes records even if relation is NULL  
 * 
 * LEFT JOIN and LEFT OUTER JOIN are IDENTICAL in PostgreSQL.
 * OUTER keyword is optional and ignored by SQL optimizer.
*/