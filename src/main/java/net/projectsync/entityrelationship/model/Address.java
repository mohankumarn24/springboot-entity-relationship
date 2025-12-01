package net.projectsync.entityrelationship.model;

import javax.persistence.*;

import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class Address {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String houseName;
    private String streetNo;
    private String city;
    private String state;
    private String country;

    @Version
    private Long version;
}
