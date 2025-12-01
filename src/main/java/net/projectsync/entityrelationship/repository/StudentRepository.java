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
	
	@Query("SELECT s FROM Student s LEFT JOIN FETCH s.address WHERE s.id = :id")
	Optional<Student> findBase(@Param("id") Long id);

	@Query("SELECT DISTINCT s FROM Student s LEFT JOIN FETCH s.phones WHERE s.id = :id")
	Optional<Student> fetchPhones(@Param("id") Long id);

	@Query("SELECT DISTINCT s FROM Student s LEFT JOIN FETCH s.projects WHERE s.id = :id")
	Optional<Student> fetchProjects(@Param("id") Long id);

	@Query("SELECT DISTINCT s FROM Student s INNER JOIN s.projects p WHERE p.projectName = :name")
	List<Student> findByProjectName(@Param("name") String name);

	@Query("SELECT DISTINCT s FROM Student s INNER JOIN s.phones p")
	List<Student> withPhones();

	@Query("SELECT s FROM Student s LEFT JOIN s.phones p WHERE p IS NULL")
	List<Student> withoutPhones();

	@Query("SELECT s FROM Student s INNER JOIN s.address a")
	List<Student> withAddress();

	@Query("SELECT s FROM Student s LEFT JOIN s.address a WHERE a IS NULL")
	List<Student> withoutAddress();
}
