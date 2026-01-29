package model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Orders")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @Column(name = "OrderDate")
    private LocalDateTime orderDate = LocalDateTime.now();

    @Column(name = "Status", length = 20)
    private String status = "PENDING";

    @Column(name = "ShippingAddress", length = 255)
    private String shippingAddress;

    @Column(name = "TotalAmount", precision = 12, scale = 2)
    private BigDecimal totalAmount = BigDecimal.ZERO;

    // THÔNG TIN NGƯỜI NHẬN (snapshot lúc đặt hàng)
    @Column(name = "RecipientName", length = 100)
    private String recipientName;

    @Column(name = "RecipientEmail", length = 100)
    private String recipientEmail;

    @Column(name = "RecipientPhone", length = 20)
    private String recipientPhone;

    // QUAN HỆ @ManyToOne: nhiều Orders - 1 User
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UserId", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private User user;

    // QUAN HỆ @OneToMany: 1 Order - nhiều OrderDetails
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private List<OrderDetail> orderDetails = new ArrayList<>();

    // Constructor thủ công để tương thích với code cũ
    public Order(User user, String shippingAddress) {
        this.orderDate = LocalDateTime.now();
        this.status = "PENDING";
        this.totalAmount = BigDecimal.ZERO;
        this.user = user;
        this.shippingAddress = shippingAddress;
    }
    
    @Transient
    private static final java.time.format.DateTimeFormatter ORDER_DATE_FMT =
            java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    @Transient
    public String getOrderDateFormatted() {
        return (orderDate == null) ? "" : orderDate.format(ORDER_DATE_FMT);
    }
}
