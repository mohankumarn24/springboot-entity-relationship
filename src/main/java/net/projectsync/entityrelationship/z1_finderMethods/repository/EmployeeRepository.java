package net.projectsync.entityrelationship.z1_finderMethods.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import net.projectsync.entityrelationship.z1_finderMethods.models.Department;
import net.projectsync.entityrelationship.z1_finderMethods.models.Employee;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {

	/*
    =====================================================
    DEFAULT METHODS AVAILABLE FROM JpaRepository
    No need to declare these. Already available.
    =====================================================

    // SAVE
    <S extends Employee> S save(S entity);
    <S extends Employee> List<S> saveAll(Iterable<S> entities);

    // FIND
    Optional<Employee> findById(Long id);
    List<Employee> findAll();
    List<Employee> findAllById(Iterable<Long> ids);

    // EXISTS
    boolean existsById(Long id);

    // COUNT
    long count();

    // DELETE
    void delete(Employee entity);
    void deleteById(Long id);
    void deleteAll();
    void deleteAll(Iterable<? extends Employee> entities);
    void deleteAllById(Iterable<? extends Long> ids);

    // FLUSH
    void flush();

    // SAVE + FLUSH
    <S extends Employee> S saveAndFlush(S entity);
    <S extends Employee> List<S> saveAllAndFlush(Iterable<S> entities);

    // BATCH DELETE
    void deleteAllInBatch();
    void deleteAllInBatch(Iterable<Employee> entities);
    void deleteAllByIdInBatch(Iterable<Long> ids);
	*/

    // ------------------------------------------------------------------
    // DEFAULT METHODS AVAILABLE FROM PagingAndSortingRepository
    // No need to declare these. Already available.
    // ------------------------------------------------------------------
	
    /*
        List<Employee> findAll(Sort sort);
        Page<Employee> findAll(Pageable pageable);
    */

    // =====================================================
    // EXISTS
    // =====================================================
    boolean existsByEmail(String email);									// SELECT EXISTS(SELECT 1 FROM employee WHERE email = ?)
    boolean existsByFirstName(String firstName);							// SELECT EXISTS(SELECT 1 FROM employee WHERE first_name = ?)
    boolean existsByDepartment_Id(Long departmentId);						// SELECT EXISTS(SELECT 1 FROM employee WHERE department_id = ?)
    boolean existsByDepartment_Name(String departmentName);					// SELECT EXISTS(SELECT 1 FROM employee e JOIN department d ON e.department_id=d.id WHERE d.name=?)
    																		// For nested properties like 'department.name' becomes 'Department_Name'

    // =====================================================
    // FIND BY SINGLE FIELD
    // =====================================================
    List<Employee> findByFirstName(String firstName);						// SELECT * FROM employee WHERE first_name = ?
    List<Employee> findByLastName(String lastName);							// SELECT * FROM employee WHERE last_name = ?
    Optional<Employee> findByEmail(String email);							// SELECT * FROM employee WHERE email = ?
    List<Employee> findByAge(Integer age);									// SELECT * FROM employee WHERE age = ?
    List<Employee> findBySalary(Double salary);								// SELECT * FROM employee WHERE salary = ?
    List<Employee> findByIsActive(Boolean isActive);						// SELECT * FROM employee WHERE is_active = ?

    // =====================================================
    // FIND USING DEPARTMENT
    // =====================================================
    
    // Department dept = departmentRepository.findById(1L).get();
    // employeeRepository.findByDepartment(dept);
    List<Employee> findByDepartment(Department department);					// SQL : SELECT * FROM employee WHERE department_id = ?
    																		// JPQL: SELECT e FROM Employee e WHERE e.department = :department
    
    List<Employee> findByDepartment_Id(Long departmentId);					// SELECT * FROM employee WHERE department_id = ?
    List<Employee> findByDepartment_Name(String departmentName);			// SELECT e.* FROM employee e JOIN department d ON e.department_id=d.id WHERE d.name=?

    // =====================================================
    // MULTIPLE CONDITIONS
    // =====================================================
    List<Employee> findByFirstNameAndLastName(String firstName, String lastName);			  // SELECT * FROM employee WHERE first_name=? AND last_name=?
    List<Employee> findByDepartment_NameAndIsActive(String departmentName, Boolean isActive); // SELECT e.* FROM employee e JOIN department d ON e.department_id=d.id WHERE d.name=? AND e.is_active=?
    Optional<Employee> findByEmailAndIsActive(String email, Boolean isActive);				  // SELECT * FROM employee WHERE email=? AND is_active=?

    // =====================================================
    // OR CONDITIONS
    // =====================================================
    List<Employee> findByFirstNameOrLastName(String firstName, String lastName);	// SELECT * FROM employee WHERE first_name=? OR last_name=?
    List<Employee> findByFirstNameOrEmail(String firstName, String email);			// SELECT * FROM employee WHERE first_name=? OR email=?

    // =====================================================
    // COMPARISON
    // =====================================================
    List<Employee> findByAgeGreaterThan(Integer age);								// SELECT * FROM employee WHERE age > ?
    List<Employee> findByAgeGreaterThanEqual(Integer age);							// SELECT * FROM employee WHERE age >= ?
    List<Employee> findByAgeLessThan(Integer age);									// SELECT * FROM employee WHERE age < ?
    List<Employee> findByAgeLessThanEqual(Integer age);								// SELECT * FROM employee WHERE age <= ?
    List<Employee> findBySalaryGreaterThan(Double salary);							// SELECT * FROM employee WHERE salary > ?
    List<Employee> findBySalaryLessThan(Double salary);								// SELECT * FROM employee WHERE salary < ?
    List<Employee> findBySalaryBetween(Double minSalary, Double maxSalary);			// SELECT * FROM employee WHERE salary BETWEEN ? AND ?

    // =====================================================
    // STRING SEARCH (LIKE / starts with / ends with / contains)
    // =====================================================
	// provide wildcards yourself for 'like' ONLY: repo.findByFirstNameLike("%John%");
    List<Employee> findByFirstNameLike(String pattern);								// SELECT * FROM employee WHERE first_name LIKE ?
    List<Employee> findByFirstNameStartingWith(String prefix);						// SELECT * FROM employee WHERE first_name LIKE 'value%'
    List<Employee> findByFirstNameEndingWith(String suffix);						// SELECT * FROM employee WHERE first_name LIKE '%value'
    List<Employee> findByFirstNameContaining(String keyword);						// SELECT * FROM employee WHERE first_name LIKE '%value%'
    List<Employee> findByEmailContaining(String keyword);							// SELECT * FROM employee WHERE email LIKE '%value%'
    List<Employee> findByAddressContaining(String keyword);							// SELECT * FROM employee WHERE address LIKE '%value%'	
    List<Employee> findByAddressContainingIgnoreCase(String keyword);				// SELECT * FROM employee WHERE LOWER(address) LIKE LOWER('%value%')
    List<Employee> findByFirstNameNotContaining(String keyword);					// SELECT * FROM employee WHERE first_name NOT LIKE '%value%'

    // =====================================================
    // IGNORE CASE
    // =====================================================
    List<Employee> findByFirstNameIgnoreCase(String firstName);						// SELECT * FROM employee WHERE LOWER(first_name)=LOWER(?)
    List<Employee> findByLastNameIgnoreCase(String lastName);						// SELECT * FROM employee WHERE LOWER(last_name)=LOWER(?)
    List<Employee> findByEmailIgnoreCase(String email);								// SELECT * FROM employee WHERE LOWER(email)=LOWER(?)
    // Optional<Employee> findByEmailIgnoreCase(String email);
    List<Employee> findByFirstNameContainingIgnoreCase(String keyword);				// SELECT * FROM employee WHERE LOWER(first_name) LIKE LOWER('%value%')

    // =====================================================
    // BOOLEAN
    // =====================================================
    List<Employee> findByIsActiveTrue();											// SELECT * FROM employee WHERE is_active=true
    List<Employee> findByIsActiveFalse();											// SELECT * FROM employee WHERE is_active=false
    
    // =====================================================
    // ORDER BY
    // =====================================================
    List<Employee> findByDepartment_NameOrderBySalaryDesc(String departmentName);		// SELECT e.* FROM employee e JOIN department d ON e.department_id=d.id WHERE d.name=? ORDER BY salary DESC
    List<Employee> findByDepartment_NameOrderByFirstNameAsc(String departmentName);		// SELECT e.* FROM employee e JOIN department d ON e.department_id=d.id WHERE d.name=? ORDER BY first_name ASC
    List<Employee> findByIsActiveTrueOrderBySalaryDesc();								// SELECT * FROM employee WHERE is_active=true ORDER BY salary DESC

    // =====================================================
    // TOP / FIRST
    // =====================================================
    // Highest paid employee with given phone number
    Optional<Employee> findFirstByPhoneNumberOrderBySalaryDesc(String phoneNumber);		// SELECT * FROM employee WHERE phone_number=? ORDER BY salary DESC LIMIT 1

    // Highest paid employee in a department by department id
    Optional<Employee> findFirstByDepartment_IdOrderBySalaryDesc(Long departmentId);	// SELECT * FROM employee WHERE department_id=? ORDER BY salary DESC LIMIT 1

    // Highest paid active employee
    Optional<Employee> findFirstByIsActiveTrueOrderBySalaryDesc();						// SELECT * FROM employee WHERE is_active=true ORDER BY salary DESC LIMIT 1

    // Highest paid employee
    Optional<Employee> findFirstByOrderBySalaryDesc();									// SELECT * FROM employee ORDER BY salary DESC LIMIT 1

    // Same as above (Top and First are interchangeable)
    Optional<Employee> findTopByOrderBySalaryDesc();									// SELECT * FROM employee ORDER BY salary DESC LIMIT 1

    // Top 5 highest paid employees
    List<Employee> findTop5ByOrderBySalaryDesc();										// SELECT * FROM employee ORDER BY salary DESC LIMIT 5

    // Top 3 highest paid employees in a department
    List<Employee> findTop3ByDepartment_NameOrderBySalaryDesc(String departmentName);	
    																			// SELECT e.* FROM employee e JOIN department d ON e.department_id=d.id WHERE d.name=? ORDER BY salary DESC LIMIT 3

    // =====================================================
    // COUNT
    // =====================================================
    long countByDepartment_Name(String departmentName);							// SELECT COUNT(*) FROM employee e JOIN department d ON e.department_id=d.id WHERE d.name=?
    long countByIsActive(Boolean isActive);										// SELECT COUNT(*) FROM employee WHERE is_active=?

    // =====================================================
    // DELETE
    // =====================================================
    void deleteByEmail(String email);											// DELETE FROM employee WHERE email=?
    void deleteByDepartment_Name(String departmentName);						// DELETE FROM employee WHERE department_id IN (SELECT id FROM department WHERE name = ?)

    // =====================================================
    // SORT
    // =====================================================
    List<Employee> findByDepartment_Name(String departmentName, Sort sort);		// SELECT e.* FROM employee e JOIN department d ON e.department_id=d.id WHERE d.name=? ORDER BY <dynamic sort>
    List<Employee> findByIsActive(Boolean isActive, Sort sort);					// SELECT * FROM employee WHERE is_active=? ORDER BY <dynamic sort>

    // =====================================================
    // PAGE
    // =====================================================
    Page<Employee> findByDepartment_Name(String departmentName, Pageable pageable);						// SELECT e.* FROM employee e JOIN department d ON e.department_id=d.id WHERE d.name=? LIMIT ? OFFSET ?
    Page<Employee> findByIsActive(Boolean isActive, Pageable pageable);									// SELECT * FROM employee WHERE is_active=? LIMIT ? OFFSET ?
    Page<Employee> findByFirstNameContainingIgnoreCase(String keyword, Pageable pageable);				// SELECT * FROM employee WHERE LOWER(first_name) LIKE LOWER('%value%') LIMIT ? OFFSET ?

    // =====================================================
    // SLICE
    // =====================================================
    Slice<Employee> findByDepartment_NameOrderBySalaryDesc(String departmentName, Pageable pageable);	// SELECT e.* FROM employee e JOIN department d ON e.department_id=d.id WHERE d.name=? ORDER BY salary DESC LIMIT ? OFFSET ?
    Slice<Employee> findByIsActiveTrue(Pageable pageable);												// SELECT * FROM employee WHERE is_active=true LIMIT ? OFFSET ?
}
