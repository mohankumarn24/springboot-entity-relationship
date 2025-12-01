package net.projectsync.entityrelationship.controller;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import net.projectsync.entityrelationship.dto.ProjectDTO;
import net.projectsync.entityrelationship.dto.StudentCreateDTO;
import net.projectsync.entityrelationship.dto.StudentDTO;
import net.projectsync.entityrelationship.dto.StudentUpdateDTO;
import net.projectsync.entityrelationship.service.StudentService;

@RestController
@RequestMapping("/api/v1/students")
@RequiredArgsConstructor
@Tag(name = "Student API", description = "CRUD and JOIN operations")
public class StudentController {

	private final StudentService studentService;

	// ---------- CREATE ----------
	@Operation(summary = "Create a student")
	@PostMapping
	public StudentDTO create(@RequestBody StudentCreateDTO dto) {
		return studentService.createStudent(dto);
	}

	// ---------- READ ----------
	// LAZY Loading -> No inner joins except Many-to-Many
	@Operation(summary = "Get student by ID")
	@GetMapping("/{id}")
	public StudentDTO getById(@PathVariable Long id) {
		return studentService.getById(id);
	}

	@Operation(summary = "Get all students")
	@GetMapping
	public List<StudentDTO> getAll() {
		return studentService.getAll();
	}

	// ---------- UPDATE ----------
	@Operation(summary = "Update student by ID")
	@PutMapping("/{id}")
	public StudentDTO update(@PathVariable Long id, @RequestBody StudentUpdateDTO dto) {
		return studentService.update(id, dto);
	}

	// ---------- PATCH ----------
	@Operation(summary = "Partial update student")
	@PatchMapping("/{id}")
	public StudentDTO patch(@PathVariable Long id, @RequestBody StudentUpdateDTO dto) {
	    return studentService.patch(id, dto);
	}
	
	// ---------- DELETE ----------
	@Operation(summary = "Delete student by ID")
	@DeleteMapping("/{id}")
	public void delete(@PathVariable Long id) {
		studentService.delete(id);
	}
	
	// ---------- JOIN CASES ----------
	// EAGER Loading -> Has inner joins
	@Operation(summary = "Get student with Address, Phones, Projects")
	@GetMapping("/{id}/full")
	public StudentDTO getFull(@PathVariable Long id) {
		return studentService.getFull(id);
	}

	@Operation(summary = "Get students by project name")
	@GetMapping("/project/{name}")
	public List<StudentDTO> getByProject(@PathVariable String name) {
		return studentService.getByProject(name);
	}

	@Operation(summary = "Get students with phones")
	@GetMapping("/with-phones")
	public List<StudentDTO> withPhones() {
		return studentService.withPhones();
	}

	@Operation(summary = "Get students without phones")
	@GetMapping("/without-phones")
	public List<StudentDTO> withoutPhones() {
		return studentService.withoutPhones();
	}

	@Operation(summary = "Get projects of a student")
	@GetMapping("/{id}/projects")
	public List<ProjectDTO> studentProjects(@PathVariable Long id) {
		return studentService.getProjects(id);
	}
}
