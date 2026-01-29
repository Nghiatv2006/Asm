package model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "ProductInteractions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductInteraction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @Column(name = "UserId", nullable = false)
    private int userId;

    @Column(name = "ProductId", nullable = false)
    private int productId;

    @Column(name = "ActionType", length = 10)
    private String actionType; // "LIKE" hoặc "DISLIKE"

    @Column(name = "ActionDate")
    private LocalDateTime actionDate = LocalDateTime.now();

    // Constructor thủ công để tương thích với code cũ
    public ProductInteraction(int userId, int productId, String actionType) {
        this.userId = userId;
        this.productId = productId;
        this.actionType = actionType;
        this.actionDate = LocalDateTime.now();
    }
}
