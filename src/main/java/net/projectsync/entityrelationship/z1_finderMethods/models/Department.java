package net.projectsync.entityrelationship.z1_finderMethods.models;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

@Entity
public class Department {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @OneToMany(cascade=CascadeType.ALL, fetch=FetchType.LAZY, mappedBy="department", orphanRemoval = true)
    private List<Employee> employees = new ArrayList<>();

    public Department() {
    }

    public Department(String name, List<Employee> employees) {
        this.name = name;
        this.employees = employees;
    }

    public Long getId() { return id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public List<Employee> getEmployees() { return employees; }
    public void setEmployees(List<Employee> employees) { this.employees = employees; }

    // extra methods
    public void addEmployee(Employee employee) {
        employee.setDepartment(this);
        this.employees.add(employee);
    }

    public void removeEmployee(Employee employee) {
        employee.setDepartment(null);
        this.employees.remove(employee);
    }

    // Base equality only on the primary key
    @Override
    public boolean equals(Object o) {
        if (this == o) {
        	return true;
        }
        
        if (!(o instanceof Department)) {
        	return false;
        }
        
        Department other = (Department) o;
        return id != null && id.equals(other.id);
    }

    // class hash
    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
	
    // Emplyoyee not added as it may trigger lazy loading and recursion
    @Override
    public String toString() {
        return String.format("Department{id=%d, name='%s'}", id, name);
    }
}
