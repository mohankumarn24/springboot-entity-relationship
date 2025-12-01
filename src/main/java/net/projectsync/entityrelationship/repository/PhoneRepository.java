package net.projectsync.entityrelationship.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import net.projectsync.entityrelationship.model.Phone;

public interface PhoneRepository extends JpaRepository<Phone, Long> {

}
