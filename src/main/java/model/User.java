package model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "Users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @Column(name = "Username", nullable = false, unique = true, length = 50)
    private String username;

    @Column(name = "Email", nullable = true, unique = true, length = 100)
    private String email;

    @Column(name = "Password", nullable = false, length = 255)
    private String password;

    @Column(name = "FullName", length = 100)
    private String fullName;

    @Column(name = "Phone", length = 20)
    private String phone;

    @Column(name = "Address", length = 255)
    private String address;

    @Column(name = "Role", length = 10)
    private String role = "USER";

    @Column(name = "CreatedDate")
    private LocalDateTime createdDate;

    // Constructor thủ công để tương thích với code cũ (RegisterServlet)
    public User(String username, String email, String password, String fullName) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.role = "USER";
    }

    // Method format ngày tạo (dùng cho JSP)
    @Transient
    public String getCreatedDateFormatted() {
        if (createdDate == null) return "";
        return createdDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }
}
