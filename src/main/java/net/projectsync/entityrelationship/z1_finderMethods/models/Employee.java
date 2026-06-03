package net.projectsync.entityrelationship.z1_finderMethods.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Entity
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String firstName;
    private String lastName;

    @Column(unique = true, nullable = false)
    private String email;

    private String address;
    private String phoneNumber;
    private Integer age;
    private Double salary;
    private Boolean isActive;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id")
    private Department department;

    public Employee() {
    }

    public Employee(String firstName, String lastName, String email, String address, String phoneNumber, Integer age, Double salary, Boolean isActive, Department department) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.age = age;
        this.salary = salary;
        this.isActive = isActive;
        this.department = department;
    }

    public Long getId() { return id; }
    
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }

    public Double getSalary() { return salary; }
    public void setSalary(Double salary) { this.salary = salary; }

    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }

    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }

    // Base equality only on primary key
    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }

        if (!(o instanceof Employee)) {
            return false;
        }

        Employee other = (Employee) o;

        return id != null && id.equals(other.id);
    }

    // Class hash
    @Override
    public int hashCode() {
        return getClass().hashCode();
    }

    // Department not included to avoid lazy loading and recursion
    @Override
    public String toString() {
        return String.format(
                "Employee{id=%s, firstName='%s', lastName='%s', email='%s', address='%s', phoneNumber='%s', age=%s, salary=%s, active=%s}",
                id, firstName, lastName, email, address, phoneNumber, age, salary, isActive
        );
    }
}