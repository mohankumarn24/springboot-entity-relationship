package net.projectsync.entityrelationship.service;

import java.util.*;
import javax.persistence.EntityNotFoundException;
import javax.persistence.OptimisticLockException;
import javax.transaction.Transactional;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import net.projectsync.entityrelationship.dto.*;
import net.projectsync.entityrelationship.mapper.StudentMapper;
import net.projectsync.entityrelationship.model.*;
import net.projectsync.entityrelationship.repository.ProjectRepository;
import net.projectsync.entityrelationship.repository.StudentRepository;

@Service
@RequiredArgsConstructor
@Transactional
public class StudentService {

    private final StudentRepository studentRepository;
    private final ProjectRepository projectRepository;

    // =====================================================
    // CREATE
    // =====================================================

    public StudentDTO createStudent(StudentCreateDTO dto) {

        Student s = StudentMapper.toNewEntity(dto);

        // Projects: may reuse existing or create new
        if (dto.getProjects() != null) {
            s.setProjects(
                    dto.getProjects().stream()
                            .map(this::resolveProjectForCreate)
                            .toList()
            );
        }

        return StudentMapper.toDTO(studentRepository.save(s));
    }

    // =====================================================
    // PUT (FULL REPLACE)
    // =====================================================

    public StudentDTO update(Long id, StudentUpdateDTO dto) {

        Student s = findStudent(id);

        // 1) optimistic lock at root
        if (dto.getVersion() == null) {
            throw new OptimisticLockException("Student version is required for PUT");
        }
        checkVersion("Student", s.getId(), s.getVersion(), dto.getVersion());

        // 2) full required fields
        if (dto.getFirstName() == null ||
            dto.getLastName() == null ||
            dto.getEmail() == null) {
            throw new IllegalArgumentException("PUT requires firstName, lastName and email");
        }

        // basic fields
        StudentMapper.applyPutOnStudentBasic(s, dto);

        // nested
        applyPutOnAddress(s, dto.getAddress());
        applyPutOnPhones(s, dto.getPhones());
        applyPutOnProjects(s, dto.getProjects());

        return StudentMapper.toDTO(s);
    }

    // =====================================================
    // PATCH (PARTIAL)
    // =====================================================

    public StudentDTO patch(Long id, StudentUpdateDTO dto) {

        Student s = findStudent(id);

        // optional optimistic locking for root
        if (dto.getVersion() != null) {
            checkVersion("Student", s.getId(), s.getVersion(), dto.getVersion());
        }

        StudentMapper.applyPatchOnStudentBasic(s, dto);

        if (dto.getAddress() != null)
            applyPatchOnAddress(s, dto.getAddress());

        if (dto.getPhones() != null)
            applyPatchOnPhones(s, dto.getPhones());

        if (dto.getProjects() != null)
            applyPatchOnProjects(s, dto.getProjects());

        return StudentMapper.toDTO(s);
    }

    // =====================================================
    // READ
    // =====================================================

    public StudentDTO getById(Long id) {
        return StudentMapper.toDTO(findStudent(id));
    }

    public List<StudentDTO> getAll() {
        return studentRepository.findAll().stream()
                .map(StudentMapper::toDTO)
                .toList();
    }

    // =====================================================
    // DELETE
    // =====================================================

    public void delete(Long id) {
        studentRepository.delete(findStudent(id));
    }

    // =====================================================
    // FULL FETCH / JOIN CASES (unchanged)
    // =====================================================

    public StudentDTO getFull(Long id) {

        studentRepository.findBase(id)
                .orElseThrow(() -> new EntityNotFoundException("Student not found"));

        studentRepository.fetchPhones(id);
        studentRepository.fetchProjects(id);

        return StudentMapper.toDTO(findStudent(id));
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
        findStudent(id); // validate
        return projectRepository.findByStudent(id)
                .stream().map(StudentMapper::toProjectDTO).toList();
    }

    // =====================================================
    // OPTIMISTIC LOCK HELPERS
    // =====================================================

    private void checkVersion(String type,
                              Long entityId,
                              Long currentVersion,
                              Long incomingVersion) {

        if (!Objects.equals(currentVersion, incomingVersion)) {
            throw new OptimisticLockException(
                    type + " " + entityId +
                    " has version " + currentVersion +
                    " but request used " + incomingVersion
            );
        }
    }

    // =====================================================
    // ADDRESS (PUT / PATCH)
    // =====================================================

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
            checkVersion("Address",
                    s.getAddress().getId(),
                    s.getAddress().getVersion(),
                    dto.getVersion());
        }

        s.getAddress().setHouseName(dto.getHouseName());
        s.getAddress().setStreetNo(dto.getStreetNo());
        s.getAddress().setCity(dto.getCity());
        s.getAddress().setState(dto.getState());
        s.getAddress().setCountry(dto.getCountry());
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

    // =====================================================
    // PHONES (PUT / PATCH)
    // =====================================================

    // PUT: replace full list
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

    // =====================================================
    // PROJECTS (PUT / PATCH)
    // =====================================================

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

    // PUT: full replace
    private void applyPutOnProjects(Student s, List<ProjectDTO> dtos) {

        s.getProjects().clear();

        if (dtos == null) return;

        List<Project> newProjects = new ArrayList<>();

        for (ProjectDTO dto : dtos) {

            if (dto.getId() != null) {
                Project p = projectRepository.findById(dto.getId())
                        .orElseThrow(() -> new EntityNotFoundException("Project not found: " + dto.getId()));

                if (dto.getVersion() != null) {
                    checkVersion("Project", p.getId(), p.getVersion(), dto.getVersion());
                }

                p.setProjectName(dto.getProjectName()); // shared entity will be updated
                newProjects.add(p);

            } else {
                Project p = new Project();
                p.setProjectName(dto.getProjectName());
                newProjects.add(p);
            }
        }

        s.getProjects().addAll(newProjects);
    }

    // PATCH: update ones provided, keep others; if a project is absent → keep it
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
    // HELPER
    // =====================================================

    private Student findStudent(Long id) {
        return studentRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Student not found: " + id));
    }
}
