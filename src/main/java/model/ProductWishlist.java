package model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "ProductWishlist", uniqueConstraints = @UniqueConstraint(columnNames = {"UserId", "ProductId"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductWishlist {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    // Quan hệ: nhiều wishlist - 1 user
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UserId")
    private User user;

    // Quan hệ: nhiều wishlist - 1 product
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ProductId")
    private Product product;
}
