package net.projectsync.entityrelationship.z1_finderMethods.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import net.projectsync.entityrelationship.z1_finderMethods.models.Department;

public interface DepartmentRepository extends JpaRepository<Department, Long> {

    /*
    =====================================================
    DEFAULT METHODS AVAILABLE FROM JpaRepository
    No need to declare these. Already available.
    =====================================================

    // SAVE
    <S extends Department> S save(S entity);
    <S extends Department> List<S> saveAll(Iterable<S> entities);

    // FIND
    Optional<Department> findById(Long id);
    List<Department> findAll();
    List<Department> findAllById(Iterable<Long> ids);

    // EXISTS
    boolean existsById(Long id);

    // COUNT
    long count();

    // DELETE
    void delete(Department entity);
    void deleteById(Long id);
    void deleteAll();
    void deleteAll(Iterable<? extends Department> entities);
    void deleteAllById(Iterable<? extends Long> ids);

    // FLUSH
    void flush();

    // SAVE + FLUSH
    <S extends Department> S saveAndFlush(S entity);
    <S extends Department> List<S> saveAllAndFlush(Iterable<S> entities);

    // BATCH DELETE
    void deleteAllInBatch();
    void deleteAllInBatch(Iterable<Department> entities);
    void deleteAllByIdInBatch(Iterable<Long> ids);
    */


    // ------------------------------------------------------------------
    // DEFAULT METHODS AVAILABLE FROM PagingAndSortingRepository
    // No need to declare these. Already available.
    // ------------------------------------------------------------------

    /*
        List<Department> findAll(Sort sort);
        Page<Department> findAll(Pageable pageable);
    */


    // =====================================================
    // EXISTS
    // =====================================================

    // SELECT EXISTS(SELECT 1 FROM department WHERE name = ?)
    boolean existsByName(String name);


    // =====================================================
    // FINDERS
    // =====================================================
    Optional<Department> findByName(String name);							// SELECT * FROM department WHERE name = ?
    List<Department> findByNameContaining(String keyword);					// SELECT * FROM department WHERE name LIKE '%value%'
    List<Department> findByNameStartingWith(String prefix);					// SELECT * FROM department WHERE name LIKE 'value%'
    List<Department> findByNameEndingWith(String suffix);					 // SELECT * FROM department WHERE name LIKE '%value'
    List<Department> findByNameIgnoreCase(String name);						// SELECT * FROM department WHERE LOWER(name)=LOWER(?)    
    List<Department> findByNameContainingIgnoreCase(String keyword);		// SELECT * FROM department WHERE LOWER(name) LIKE LOWER('%value%')

    // =====================================================
    // COLLECTION QUERIES
    // =====================================================
    List<Department> findByEmployeesIsNotEmpty();							// SELECT d.* FROM department d WHERE EXISTS (SELECT 1 FROM employee e WHERE e.department_id = d.id)
    List<Department> findByEmployeesIsEmpty();								// SELECT d.* FROM department d WHERE NOT EXISTS (SELECT 1 FROM employee e WHERE e.department_id = d.id)

    // =====================================================
    // AND / OR
    // =====================================================
    List<Department> findByNameOrId(String name, Long id);					// SELECT * FROM department WHERE name=? OR id=?
    Optional<Department> findByNameAndId(String name, Long id);				// SELECT * FROM department WHERE name=? AND id=?

    // =====================================================
    // COMPARISON
    // =====================================================    
    List<Department> findByIdGreaterThan(Long id);							// SELECT * FROM department WHERE id > ?
    List<Department> findByIdLessThan(Long id);								// SELECT * FROM department WHERE id < ?
    List<Department> findByIdBetween(Long startId, Long endId);				// SELECT * FROM department WHERE id BETWEEN ? AND ?

    // =====================================================
    // IN / NOT IN
    // =====================================================
    List<Department> findByNameIn(List<String> names);						// SELECT * FROM department WHERE name IN (?, ?, ...)
    List<Department> findByIdIn(List<Long> ids);							// SELECT * FROM department WHERE id IN (?, ?, ...)
    List<Department> findByNameNotIn(List<String> names);					// SELECT * FROM department WHERE name NOT IN (?, ?, ...)

    // =====================================================
    // NULL CHECKS
    // =====================================================    
    List<Department> findByNameIsNull();									// SELECT * FROM department WHERE name IS NULL
    List<Department> findByNameIsNotNull();									// SELECT * FROM department WHERE name IS NOT NULL


    // =====================================================
    // DISTINCT
    // =====================================================
    List<Department> findDistinctByNameContaining(String keyword);			// SELECT DISTINCT * FROM department WHERE name LIKE '%value%'

    // =====================================================
    // COUNT
    // =====================================================    
    long countByName(String name);											// SELECT COUNT(*) FROM department WHERE name = ?

    // =====================================================
    // DELETE
    // =====================================================
    void deleteByName(String name);											// DELETE FROM department WHERE name = ?

    // =====================================================
    // ORDER BY
    // =====================================================
    List<Department> findAllByOrderByNameAsc();								// SELECT * FROM department ORDER BY name ASC
    List<Department> findAllByOrderByNameDesc();							// SELECT * FROM department ORDER BY name DESC

    // =====================================================
    // TOP / FIRST
    // =====================================================
    Optional<Department> findFirstByOrderByNameAsc();						// SELECT * FROM department ORDER BY name ASC LIMIT 1
    List<Department> findTop3ByOrderByNameAsc();							// SELECT * FROM department ORDER BY name ASC LIMIT 3

    // =====================================================
    // PAGING
    // =====================================================
    Page<Department> findByNameContainingIgnoreCase(String keyword, Pageable pageable);	// SELECT * FROM department WHERE LOWER(name) LIKE LOWER('%value%') LIMIT ? OFFSET ?
}
