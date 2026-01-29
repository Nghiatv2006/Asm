package model;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "Products")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @Column(name = "BookTitle", nullable = false, length = 200)
    private String bookTitle;

    @Column(name = "Author", length = 100)
    private String author;

    @Column(name = "Publisher", length = 100)
    private String publisher;

    @Column(name = "Price", nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Column(name = "StockQuantity")
    private Integer stockQuantity = 0;

    @Column(name = "Description", columnDefinition = "NVARCHAR(MAX)")
    private String description;

    @Column(name = "ImagePath", length = 255)
    private String imagePath;

    @Column(name = "ViewCount")
    private Integer viewCount = 0;

    @Column(name = "LikeCount")
    private Integer likeCount = 0;

    @Column(name = "DislikeCount")
    private Integer dislikeCount = 0;

    @Column(name = "CreatedDate")
    private LocalDateTime createdDate = LocalDateTime.now();

    // QUAN HỆ @ManyToOne: nhiều Products - 1 Category
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CategoryId", nullable = false)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @JsonIgnore
    private Category category;

    // Constructor thủ công để tương thích với code cũ
    public Product(String bookTitle, String author, BigDecimal price, Category category) {
        this.createdDate = LocalDateTime.now();
        this.viewCount = 0;
        this.likeCount = 0;
        this.dislikeCount = 0;
        this.stockQuantity = 0;
        this.bookTitle = bookTitle;
        this.author = author;
        this.price = price;
        this.category = category;
    }
}
