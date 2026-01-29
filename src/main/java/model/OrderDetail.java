package model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;

@Entity
@Table(name = "OrderDetails")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @Column(name = "ProductId")
    private Integer productId; // Nullable - chỉ tham chiếu, không FK

    @Column(name = "BookTitle", nullable = false, length = 200)
    private String bookTitle;

    @Column(name = "ProductImage", length = 255)
    private String productImage;

    @Column(name = "ProductPrice", nullable = false, precision = 10, scale = 2)
    private BigDecimal productPrice;

    @Column(name = "Quantity")
    private Integer quantity = 1;

    // QUAN HỆ @ManyToOne: nhiều OrderDetails - 1 Order
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OrderId", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private Order order;

    // Constructor thủ công để tương thích với code cũ
    public OrderDetail(Order order, Integer productId, String bookTitle, String productImage, BigDecimal productPrice,
            Integer quantity) {
        this.order = order;
        this.productId = productId;
        this.bookTitle = bookTitle;
        this.productImage = productImage;
        this.productPrice = productPrice;
        this.quantity = quantity;
    }
}
