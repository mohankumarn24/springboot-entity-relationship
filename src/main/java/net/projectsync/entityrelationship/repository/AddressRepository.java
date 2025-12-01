package net.projectsync.entityrelationship.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import net.projectsync.entityrelationship.model.Address;

public interface AddressRepository extends JpaRepository<Address, Long> {

}
