package net.projectsync.entityrelationship.model;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Version;
import lombok.Getter;
import lombok.Setter;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Getter
@Setter
public class Phone {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String phoneModel;
    private String phoneNumber;

    @JsonIgnore									// @JsonIgnore is added for JSON serialization safety
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id")
    private Student student;

    @Version
    private Long version;
}

/*
 * 
 * - @JsonIgnore avoids infinite recursion (StackOverflow error): 
 * 
 *    since relationship is bi-directional, we have
 *    Student → phones
 *    Phone   → student
 * 
 * - When Spring converts entities to JSON:
 *    Student
 *    └─ phones[]
 *         └─ student
 *              └─ phones[]
 *                   └─ student
 *                        └─ phones[] ...
 *    This never ends...
 * 
 * - @JsonIgnore STOPS recursion. So, Serialization becomes:
 * 
 *    Student
 *    └─ phones[] (no back reference)
 *
 * - NOTE: Only affects JSON output
*/