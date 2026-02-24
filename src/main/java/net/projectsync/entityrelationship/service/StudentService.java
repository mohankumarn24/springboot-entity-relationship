package net.projectsync.entityrelationship.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import javax.persistence.EntityNotFoundException;
import javax.persistence.OptimisticLockException;
import javax.transaction.Transactional;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;
import net.projectsync.entityrelationship.dto.AddressDTO;
import net.projectsync.entityrelationship.dto.PhoneDTO;
import net.projectsync.entityrelationship.dto.ProjectDTO;
import net.projectsync.entityrelationship.dto.StudentCreateDTO;
import net.projectsync.entityrelationship.dto.StudentDTO;
import net.projectsync.entityrelationship.dto.StudentUpdateDTO;
import net.projectsync.entityrelationship.mapper.StudentMapper;
import net.projectsync.entityrelationship.model.Address;
import net.projectsync.entityrelationship.model.Phone;
import net.projectsync.entityrelationship.model.Project;
import net.projectsync.entityrelationship.model.Student;
import net.projectsync.entityrelationship.repository.ProjectRepository;
import net.projectsync.entityrelationship.repository.StudentRepository;

@Service
@RequiredArgsConstructor
@Transactional 						// Added to enable default Lazy loading as specified in entities
public class StudentService {

    private final StudentRepository studentRepository;
    private final ProjectRepository projectRepository;

    // =====================================================
    // CREATE
    // =====================================================
    public StudentDTO createStudent(StudentCreateDTO dto) {

        Student s = StudentMapper.toNewEntity(dto);

        // Projects: may reuse existing or create new
        // ManyToMany
        if (dto.getProjects() != null) {
            s.setProjects(
                    dto.getProjects().stream()
                            .map(this::resolveProjectForCreate)
                            .toList()
            );
        }
        /* same as above 'if' block
	    List<Project> projects = new ArrayList<>();
	    for (ProjectDTO projectDTO : dto.getProjects()) {
	        Project project = resolveProjectForCreate(projectDTO);
	        projects.add(project);
	    }
        */

        return StudentMapper.toDTO(studentRepository.save(s));
    }

    // For create: project version is ignored
    private Project resolveProjectForCreate(ProjectDTO dto) {
        if (dto.getId() != null) {
            return projectRepository.findById(dto.getId())
                    .orElseThrow(() -> new EntityNotFoundException(
                            "Project not found: " + dto.getId()
                    ));
        }
        Project p = new Project();
        p.setProjectName(dto.getProjectName());
        return p;
    }
    
    // =====================================================
    // READ
    // =====================================================
    public StudentDTO getById(Long id) {
        Student s = studentRepository.findById(id)
        		.orElseThrow(() -> new EntityNotFoundException("Student not found: " + id));
        return StudentMapper.toDTO(s);
    }

    public List<StudentDTO> getAll() {
        return studentRepository.findAll().stream()
                .map(StudentMapper::toDTO)
                .toList();
    }
    
    // =====================================================
    // PUT
    // =====================================================
    public StudentDTO update(Long id, StudentUpdateDTO dto) {
    	
        Student s = studentRepository.findById(id)
        		.orElseThrow(() -> new EntityNotFoundException("Student not found: " + id));

        // optimistic lock at root
        if (dto.getVersion() == null) {
            throw new OptimisticLockException("Student version is required for PUT");
        }
        checkVersion("Student", s.getId(), s.getVersion(), dto.getVersion());

        // full required fields
        // Optional: update only non-null field
        if (dto.getFirstName() == null ||
            dto.getLastName() == null ||
            dto.getEmail() == null) {
            throw new IllegalArgumentException("PUT requires firstName, lastName and email");
        }

        // basic fields
        applyPutOnStudentBasic(s, dto);

        // nested
        applyPutOnAddress(s, dto.getAddress());
        applyPutOnPhones(s, dto.getPhones());
        applyPutOnProjects(s, dto.getProjects());
        
        // update() is wrapped in a transaction (@Transactional added at service level or method level)
        // So, Hibernate tracks these changes using dirty checking. Hibernate automatically runs UPDATE, INSERT, DELETE. No need to explicitly specify save()
        // return StudentMapper.toDTO(s);						// automatic persistence / dirty checking
        return StudentMapper.toDTO(studentRepository.save(s));	// added explicit save to avoid accidental failures
    }
    
    private void applyPutOnStudentBasic(Student s, StudentUpdateDTO dto) {
        s.setFirstName(dto.getFirstName());
        s.setLastName(dto.getLastName());
        s.setEmail(dto.getEmail());
    }
    
    private void applyPutOnAddress(Student s, AddressDTO dto) {

        if (dto == null) {
            s.setAddress(null);
            return;
        }

        if (s.getAddress() == null) {
            // new address
            Address a = new Address();
            a.setHouseName(dto.getHouseName());
            a.setStreetNo(dto.getStreetNo());
            a.setCity(dto.getCity());
            a.setState(dto.getState());
            a.setCountry(dto.getCountry());
            s.setAddress(a);
            return;
        }

        // existing address, optimistic lock if version present
        if (dto.getVersion() != null) {
            checkVersion("Address", s.getAddress().getId(), s.getAddress().getVersion(), dto.getVersion());
        }

        s.getAddress().setHouseName(dto.getHouseName());
        s.getAddress().setStreetNo(dto.getStreetNo());
        s.getAddress().setCity(dto.getCity());
        s.getAddress().setState(dto.getState());
        s.getAddress().setCountry(dto.getCountry());
    }
    
    private void applyPutOnPhones(Student s, List<PhoneDTO> dtos) {

        if (dtos == null) return;

        for (PhoneDTO dto : dtos) {

            // Case 1: UPDATE existing phone
            if (dto.getId() != null) {

                Phone existing = s.getPhones().stream()
                        .filter(p -> p.getId().equals(dto.getId()))
                        .findFirst()
                        .orElseThrow(() ->
                                new RuntimeException("Phone not found: " + dto.getId()));

                existing.setPhoneModel(dto.getPhoneModel());
                existing.setPhoneNumber(dto.getPhoneNumber());
            }

            // Case 2: INSERT new phone
            else {
                Phone p = new Phone();
                p.setPhoneModel(dto.getPhoneModel());
                p.setPhoneNumber(dto.getPhoneNumber());
                p.setStudent(s);
                s.getPhones().add(p);
            }
        }
    }
    
    private void applyPutOnProjects(Student s, List<ProjectDTO> dtos) {

        s.getProjects().clear();

        if (dtos == null) return;

        List<Project> newProjects = new ArrayList<>();
        for (ProjectDTO dto : dtos) {
        	// update existing project
            if (dto.getId() != null) {
                Project p = projectRepository.findById(dto.getId())
                        .orElseThrow(() -> new EntityNotFoundException("Project not found: " + dto.getId()));

                if (dto.getVersion() != null) {
                    checkVersion("Project", p.getId(), p.getVersion(), dto.getVersion());
                }

                p.setProjectName(dto.getProjectName()); // shared entity will be updated
                newProjects.add(p);
            } 
            // project does not exist -> create new project
            else {
                Project p = new Project();
                p.setProjectName(dto.getProjectName());
                newProjects.add(p);
            }
        }

        s.getProjects().addAll(newProjects);
    }

    // =====================================================
    // PATCH
    // =====================================================
    public StudentDTO patch(Long id, StudentUpdateDTO dto) {

        Student s = studentRepository.findById(id)
        		.orElseThrow(() -> new EntityNotFoundException("Student not found: " + id));

        // optional optimistic locking for root
        if (dto.getVersion() != null) {
            checkVersion("Student", s.getId(), s.getVersion(), dto.getVersion());
        }

        applyPatchOnStudentBasic(s, dto);

        if (dto.getAddress() != null)
            applyPatchOnAddress(s, dto.getAddress());

        if (dto.getPhones() != null)
            applyPatchOnPhones(s, dto.getPhones());

        if (dto.getProjects() != null)
            applyPatchOnProjects(s, dto.getProjects());

        // return StudentMapper.toDTO(s);						// automatic persistence / dirty checking
        return StudentMapper.toDTO(studentRepository.save(s));	// added explicit save to avoid accidental failures
    }

    private void applyPatchOnStudentBasic(Student s, StudentUpdateDTO dto) {
        if (dto.getFirstName() != null) s.setFirstName(dto.getFirstName());
        if (dto.getLastName() != null)  s.setLastName(dto.getLastName());
        if (dto.getEmail() != null)     s.setEmail(dto.getEmail());
    }
    
    private void applyPatchOnAddress(Student s, AddressDTO dto) {

        Address a = s.getAddress();
        if (a == null) {
            // if any field present, create new address
            a = new Address();
            s.setAddress(a);
        } else if (dto.getVersion() != null) {
            checkVersion("Address", a.getId(), a.getVersion(), dto.getVersion());
        }

        if (dto.getHouseName() != null) a.setHouseName(dto.getHouseName());
        if (dto.getStreetNo() != null)  a.setStreetNo(dto.getStreetNo());
        if (dto.getCity() != null)      a.setCity(dto.getCity());
        if (dto.getState() != null)     a.setState(dto.getState());
        if (dto.getCountry() != null)   a.setCountry(dto.getCountry());
    }

    // PATCH: update existing, add new, keep unspecified
    private void applyPatchOnPhones(Student s, List<PhoneDTO> dtos) {

        // build map of existing Phones by id
        Map<Long, Phone> existingById = new HashMap<>();
        for (Phone p : s.getPhones()) {
            if (p.getId() != null) {
                existingById.put(p.getId(), p);
            }
        }

        for (PhoneDTO dto : dtos) {
            if (dto.getId() != null) {
                Phone existing = existingById.get(dto.getId());
                if (existing == null) {
                    throw new EntityNotFoundException("Phone not found: " + dto.getId());
                }

                // optimistic lock if version present
                if (dto.getVersion() != null) {
                    checkVersion("Phone", existing.getId(), existing.getVersion(), dto.getVersion());
                }

                if (dto.getPhoneModel() != null)
                    existing.setPhoneModel(dto.getPhoneModel());
                if (dto.getPhoneNumber() != null)
                    existing.setPhoneNumber(dto.getPhoneNumber());

            } else {
                // new phone
                Phone p = new Phone();
                p.setPhoneModel(dto.getPhoneModel());
                p.setPhoneNumber(dto.getPhoneNumber());
                p.setStudent(s);
                s.getPhones().add(p);
            }
        }
        // Note: we do NOT remove unspecified phones in PATCH
    }

    // PATCH: update ones provided, keep others; if a project is absent, keep it
    private void applyPatchOnProjects(Student s, List<ProjectDTO> dtos) {

        // Existing set as map by id
        Map<Long, Project> existingById = new HashMap<>();
        for (Project p : s.getProjects()) {
            if (p.getId() != null) existingById.put(p.getId(), p);
        }

        for (ProjectDTO dto : dtos) {
            if (dto.getId() != null) {
                Project p = projectRepository.findById(dto.getId())
                        .orElseThrow(() -> new EntityNotFoundException("Project not found: " + dto.getId()));

                if (dto.getVersion() != null) {
                    checkVersion("Project", p.getId(), p.getVersion(), dto.getVersion());
                }

                if (dto.getProjectName() != null)
                    p.setProjectName(dto.getProjectName());

                if (!s.getProjects().contains(p)) {
                    s.getProjects().add(p);
                }

            } else {
                Project p = new Project();
                p.setProjectName(dto.getProjectName());
                s.getProjects().add(p);
            }
        }
    }
    
    // =====================================================
    // DELETE
    // =====================================================
    public void delete(Long id) {
        Student s = studentRepository.findById(id)
        		.orElseThrow(() -> new EntityNotFoundException("Student not found: " + id));
        studentRepository.delete(s);
    }

    // =====================================================
    // FULL FETCH / JOIN CASES (unchanged)
    // =====================================================
    public StudentDTO getFull(Long id) {

        studentRepository.findBase(id)
                .orElseThrow(() -> new EntityNotFoundException("Student not found"));

        studentRepository.fetchPhones(id);
        studentRepository.fetchProjects(id);

        Student s = studentRepository.findById(id)
        		.orElseThrow(() -> new EntityNotFoundException("Student not found: " + id));
        
        return StudentMapper.toDTO(s);
    }

    public List<StudentDTO> getByProject(String name) {
        return studentRepository.findByProjectName(name)
                .stream().map(StudentMapper::toDTO).toList();
    }

    public List<StudentDTO> withPhones() {
        return studentRepository.withPhones()
                .stream().map(StudentMapper::toDTO).toList();
    }

    public List<StudentDTO> withoutPhones() {
        return studentRepository.withoutPhones()
                .stream().map(StudentMapper::toDTO).toList();
    }

    public List<ProjectDTO> getProjects(Long id) {
        Student s = studentRepository.findById(id)
        		.orElseThrow(() -> new EntityNotFoundException("Student not found: " + id));
        
        return projectRepository.findByStudent(id)
                .stream().map(StudentMapper::toProjectDTO).toList();
    }

    // =====================================================
    // OPTIMISTIC LOCK HELPER
    // =====================================================
    private void checkVersion(String type, Long entityId, Long currentVersion, Long incomingVersion) {

        if (!Objects.equals(currentVersion, incomingVersion)) {
        	String msg = String.format("%s %s has version %s but request used %s", type, entityId, currentVersion, incomingVersion);
            throw new OptimisticLockException(msg);
        }
    }
}


/*
MappingDefault 	Fetch
----------------------
@OneToMany		LAZY
@ManyToMany		LAZY
@ManyToOne		EAGER
@OneToOne		EAGER
----------------------


Why readOnly = true?
	- When readOnly = true, Hibernate:
 		-- Skips dirty checking — doesn't snapshot entities to detect changes
		-- Doesn't flush to DB unless explicitly needed
		-- Potentially routes to read replica (if configured)
		-- Overall faster and lighter for reads
	- It's a performance optimization, not a security lock.


// Recommended best practice
@Service
@Transactional(readOnly = true)   // class-level default
public class OrderService {

    private final OrderRepository orderRepository;

    // READ — inherits readOnly=true
    public Order getOrder(Long id) {
        return orderRepository.findById(id).orElseThrow();
    }

    // WRITE — override with readOnly=false (default @Transactional)
    @Transactional
    public Order createOrder(Order order) {
        return orderRepository.save(order);
    }

    @Transactional
    public void deleteOrder(Long id) {
        orderRepository.deleteById(id);
    }
}


// If any exception occurs, the whole operation rolls back.
@Transactional
public void transferMoney(Account from, Account to, double amount) {
    from.debit(amount);
    to.credit(amount);
}


Key Properties:
--------------
 - propagation		: how transactions interact (e.g., REQUIRED, REQUIRES_NEW, NESTED)
 - isolation		: concurrency control (READ_COMMITTED, SERIALIZABLE, etc.)
 - rollbackFor		: which exceptions trigger rollback (default: unchecked only)
 - readOnly=true	: optimization hint for read-only operations
 - timeout			: max seconds before forced rollback

*/






/*
//=============================================================
//JPA ENTITY RELATIONSHIPS - FETCH TYPES (LAZY vs EAGER)
//=============================================================

//--- DEFAULT FETCH TYPES ---
//@OneToMany  → LAZY  (collection)
//@ManyToMany → LAZY  (collection)
//@ManyToOne  → EAGER (single entity) ⚠️ often overlooked
//@OneToOne   → EAGER (single entity) ⚠️ often overlooked


//--- LAZY LOADING ---
//Data is NOT fetched from DB until you explicitly access it.
//Works only within an open Hibernate session (persistence context).
//Accessing lazy field after session closes throws:
//→ LazyInitializationException: could not initialize proxy - no Session

//Example:
//@OneToMany(mappedBy = "user", fetch = FetchType.LAZY)  // default, no need to specify
//private List<Order> orders;


//--- EAGER LOADING ---
//Data is fetched IMMEDIATELY along with the parent entity (always).
//Even if you don't need the association, it gets loaded.
//Can cause performance issues on collections → N+1 problem.

//Example:
//@OneToMany(mappedBy = "user", fetch = FetchType.EAGER)  // ⚠️ avoid on collections
//private List<Order> orders;


//--- N+1 PROBLEM (caused by EAGER or naive LAZY access in a loop) ---
//1 query to fetch all Users
//+ N queries to fetch orders for each User
//= N+1 total queries → kills performance at scale


//--- HOW TO HANDLE LAZY LOADING SAFELY ---

//Option 1: Force initialize within an open transaction
//@Transactional(readOnly = true)
//public User getUserWithOrders(Long id) {
//  User user = userRepository.findById(id).orElseThrow();
//  user.getOrders().size(); // triggers lazy load while session is open
//  return user;
//}

//Option 2: JOIN FETCH in JPQL (fetches in single query)
//@Query("SELECT u FROM User u JOIN FETCH u.orders WHERE u.id = :id")
//Optional<User> findByIdWithOrders(@Param("id") Long id);

//Option 3: @EntityGraph (cleanest, no JPQL needed)
//@EntityGraph(attributePaths = {"orders", "address"})
//Optional<User> findById(Long id);

//Option 4: Projections / DTOs (best performance — fetch only what you need)
//public interface UserSummary {
//  String getName();
//  String getEmail();
//}
//List<UserSummary> findAllProjectedBy();


//--- BEST PRACTICES ---
//✅ Keep default LAZY on @OneToMany and @ManyToMany
//✅ Use @EntityGraph or JOIN FETCH when you need associations
//✅ Use DTOs/Projections to avoid loading full entities unnecessarily
//✅ Always access lazy fields inside a @Transactional method
//❌ Never use EAGER on collections (@OneToMany, @ManyToMany)
//❌ Never access lazy fields outside a transaction / open session

//=============================================================
*/