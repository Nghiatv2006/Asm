package model;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Categories")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @Column(name = "CategoryName", nullable = false, unique = true, length = 100)
    private String categoryName;

    @Column(name = "Description", length = 255)
    private String description;

    // QUAN HỆ @OneToMany: 1 Category - nhiều Products
    // Ngắt vòng lặp toString/hashCode
    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @JsonIgnore   // THÊM DÒNG NÀY
    private List<Product> products = new ArrayList<>();

    // Constructor thủ công để tương thích với code cũ
    public Category(String categoryName, String description) {
        this.categoryName = categoryName;
        this.description = description;
    }
}
