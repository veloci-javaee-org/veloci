package mapper;

import dto.SignupRequestDto;
import enums.RoleEnum;
import models.Customer;
import models.User;

/**
 * Translates transport-layer request data (DTOs) into domain entities.
 * Keeps entities free of any knowledge of HTTP/form field names.
 */
public class CustomerMapper {

    private CustomerMapper() {
        // static utility class, no instances
    }

    public static Customer toEntity(SignupRequestDto dto) {
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(dto.getPassword()); // still plaintext here; hashing happens in the service layer
        user.setRole(RoleEnum.CUSTOMER);

        Customer customer = new Customer();
        customer.setUser(user);
        customer.setName(dto.getName());
        customer.setEmail(dto.getEmail());
        customer.setPhone(dto.getPhone());
        customer.setAddress(dto.getAddress());

        return customer;
    }
}