# 📚 Bookstore Management System

> A comprehensive Java Web Application for managing an online bookstore with modern UI/UX and advanced features.

![Java](https://img.shields.io/badge/Java-21-orange)
![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10-blue)
![Hibernate](https://img.shields.io/badge/Hibernate-6.4.4-green)
![SQL Server](https://img.shields.io/badge/SQL%20Server-2019+-red)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5-purple)

---

## 🌟 Overview

**Bookstore Management System** là một ứng dụng web quản lý cửa hàng sách trực tuyến được xây dựng bằng Java Servlet/JSP với JPA/Hibernate. Hệ thống cung cấp đầy đủ tính năng cho cả người dùng và quản trị viên, từ duyệt sách, đặt hàng đến quản lý kho hàng và thống kê kinh doanh.

### ✨ Key Highlights

- 🎨 **Modern UI/UX** với Winter Theme và glassmorphism design
- 🔐 **Email OTP Verification** cho đăng ký tài khoản
- 💝 **Wishlist System** với checkout từ danh sách yêu thích
- 👍 **Like/Dislike System** cho sản phẩm
- 📊 **Admin Dashboard** với Chart.js visualization
- 📧 **Email Integration** để chia sẻ sản phẩm
- 🔄 **RESTful API** cho Product management
- 📱 **Responsive Design** tương thích mọi thiết bị

---

## 🎯 Features

### 👤 User Features

#### 🔐 Authentication & Security
- ✅ Đăng ký tài khoản với xác thực OTP qua email
- ✅ Đăng nhập/Đăng xuất an toàn
- ✅ Quản lý thông tin cá nhân (Profile)
- ✅ Đổi mật khẩu
- ✅ Session management

#### 📖 Product Browsing
- ✅ Xem danh sách sách theo danh mục
- ✅ Tìm kiếm sách (theo tên hoặc tác giả)
- ✅ Xem chi tiết sản phẩm với thông tin đầy đủ
- ✅ Tự động tăng view count khi xem chi tiết
- ✅ Hiển thị sản phẩm liên quan cùng danh mục

#### 💫 Interaction Features
- ✅ **Like/Dislike** sản phẩm (toggle interaction)
- ✅ Thêm/Xóa sản phẩm khỏi **Wishlist**
- ✅ Chia sẻ sản phẩm qua email với HTML template đẹp mắt
- ✅ Real-time update cho số lượng like/dislike

#### 🛒 Shopping & Orders
- ✅ Đặt hàng từ Wishlist (chọn nhiều sản phẩm)
- ✅ Checkout với thông tin người nhận
- ✅ Xem lịch sử đơn hàng
- ✅ Xem chi tiết từng đơn hàng

### 👨‍💼 Admin Features

#### 📊 Dashboard & Analytics
- ✅ Tổng quan hệ thống (Users, Categories, Products, Orders)
- ✅ **Biểu đồ đơn hàng 7 ngày gần đây** (Line Chart)
- ✅ **Phân bố sản phẩm theo danh mục** (Pie Chart)
- ✅ **Top 5 sản phẩm được xem nhiều nhất** (Bar Chart)
- ✅ Danh sách đơn hàng gần đây
- ✅ Top 3 sản phẩm bán chạy
- ✅ Người dùng mới đăng ký

#### 🗂️ Data Management (CRUD)
- ✅ **User Management:** Thêm, sửa, xóa người dùng
- ✅ **Category Management:** Quản lý danh mục sách
- ✅ **Product Management:** 
  - CRUD đầy đủ cho sản phẩm
  - Upload ảnh sản phẩm
  - RESTful API endpoints
- ✅ **Order Management:**
  - Xem danh sách đơn hàng
  - Cập nhật trạng thái đơn hàng
  - Xem chi tiết đơn hàng

---

## 🛠️ Technology Stack

### Backend
- **Java 21** - Core programming language
- **Jakarta EE 10** - Enterprise Java platform
- **Servlet 6.0** - Web request handling
- **JSP & JSTL** - Server-side rendering
- **JPA 3.1** - Object-Relational Mapping
- **Hibernate 6.4.4** - JPA implementation
- **Maven** - Build automation & dependency management

### Database
- **Microsoft SQL Server 2019+** - Primary database
- **JDBC Driver** - Database connectivity

### Frontend
- **Bootstrap 5** - Responsive framework
- **Font Awesome 6** - Icons
- **Chart.js** - Data visualization
- **SweetAlert2** - Beautiful alerts
- **Custom CSS** - Animations & effects

### Libraries & Tools
- **Jackson 2.17.2** - JSON processing
- **Lombok 1.18.32** - Reduce boilerplate code
- **JavaMail 2.0.1** - Email functionality
- **Commons BeanUtils 1.9.4** - Bean utilities

---

## 📁 Project Structure

```
d:\Eclipse\Asm\
├── src/main/
│   ├── java/
│   │   ├── api/                    # RESTful API Controllers
│   │   │   ├── ProductApiServlet.java
│   │   │   ├── CategoryApiServlet.java
│   │   │   ├── UploadImageApiServlet.java
│   │   │   └── SpaServlet.java
│   │   │
│   │   ├── controller/             # MVC Controllers (22 Servlets)
│   │   │   ├── LoginServlet.java
│   │   │   ├── RegisterServlet.java
│   │   │   ├── HomeServlet.java
│   │   │   ├── ProductDetailServlet.java
│   │   │   ├── CheckoutServlet.java
│   │   │   ├── WishlistServlet.java
│   │   │   ├── LikeProductServlet.java
│   │   │   ├── ShareProductServlet.java
│   │   │   ├── SendOtpServlet.java
│   │   │   ├── VerifyOtpServlet.java
│   │   │   ├── AdminDashboardServlet.java
│   │   │   ├── UserManagementServlet.java
│   │   │   ├── CategoryManagementServlet.java
│   │   │   ├── ProductManagementServlet.java
│   │   │   ├── AdminOrdersServlet.java
│   │   │   └── ... (7 more servlets)
│   │   │
│   │   ├── filter/                 # Security Filters
│   │   │   └── AuthenticationFilter.java
│   │   │
│   │   ├── model/                  # JPA Entities (Domain Models)
│   │   │   ├── User.java
│   │   │   ├── Category.java
│   │   │   ├── Product.java
│   │   │   ├── Order.java
│   │   │   ├── OrderDetail.java
│   │   │   ├── ProductInteraction.java
│   │   │   └── ProductWishlist.java
│   │   │
│   │   └── utils/                  # Utility Classes
│   │       ├── JpaUtil.java
│   │       └── EmailUtil.java
│   │
│   ├── resources/
│   │   └── META-INF/
│   │       └── persistence.xml     # JPA Configuration
│   │
│   └── webapp/
│       ├── views/                  # JSP Views (14 pages)
│       │   ├── login.jsp
│       │   ├── register.jsp
│       │   ├── home.jsp
│       │   ├── product-detail.jsp
│       │   ├── checkout.jsp
│       │   ├── user-wishlist.jsp
│       │   ├── user-profile.jsp
│       │   ├── user-order-detail.jsp
│       │   ├── admin-dashboard.jsp
│       │   ├── admin-users.jsp
│       │   ├── admin-categories.jsp
│       │   ├── admin-products.jsp
│       │   ├── admin-orders.jsp
│       │   └── admin-order-detail.jsp
│       │
│       ├── images/                 # Product images
│       └── WEB-INF/
│           └── lib/                # JAR libraries
│
├── db/
│   └── BookstoreDB.sql            # Database schema & sample data
│
├── pom.xml                        # Maven configuration
└── README.md                      # Project documentation
```

---

## 🗄️ Database Schema

### Entity-Relationship Overview

```
User (1) ──────< (N) Order (1) ──────< (N) OrderDetail
  │                                           
  └──< (N) ProductWishlist (N) >──┐          
                                   │          
  ┌──< (N) ProductInteraction (N) ─┤
  │                                 │
Category (1) ──────< (N) Product (1)┘
```

### Tables

#### **Users**
| Column | Type | Constraints |
|--------|------|-------------|
| Id | INT | PRIMARY KEY, IDENTITY |
| Username | NVARCHAR(50) | UNIQUE, NOT NULL |
| Email | NVARCHAR(100) | UNIQUE |
| Password | NVARCHAR(255) | NOT NULL |
| FullName | NVARCHAR(100) | |
| Phone | NVARCHAR(20) | |
| Address | NVARCHAR(255) | |
| Role | NVARCHAR(10) | DEFAULT 'USER' |
| CreatedDate | DATETIME | |

#### **Categories**
| Column | Type | Constraints |
|--------|------|-------------|
| Id | INT | PRIMARY KEY, IDENTITY |
| CategoryName | NVARCHAR(100) | UNIQUE, NOT NULL |
| Description | NVARCHAR(255) | |

#### **Products**
| Column | Type | Constraints |
|--------|------|-------------|
| Id | INT | PRIMARY KEY, IDENTITY |
| BookTitle | NVARCHAR(200) | NOT NULL |
| Author | NVARCHAR(100) | |
| Publisher | NVARCHAR(100) | |
| Price | DECIMAL(10,2) | NOT NULL |
| StockQuantity | INT | DEFAULT 0 |
| Description | NVARCHAR(MAX) | |
| ImagePath | NVARCHAR(255) | |
| ViewCount | INT | DEFAULT 0 |
| LikeCount | INT | DEFAULT 0 |
| DislikeCount | INT | DEFAULT 0 |
| CreatedDate | DATETIME | |
| CategoryId | INT | FOREIGN KEY → Categories(Id) |

#### **Orders**
| Column | Type | Constraints |
|--------|------|-------------|
| Id | INT | PRIMARY KEY, IDENTITY |
| OrderDate | DATETIME | DEFAULT GETDATE() |
| Status | NVARCHAR(20) | DEFAULT 'PENDING' |
| ShippingAddress | NVARCHAR(255) | |
| TotalAmount | DECIMAL(12,2) | DEFAULT 0 |
| RecipientName | NVARCHAR(100) | |
| RecipientEmail | NVARCHAR(100) | |
| RecipientPhone | NVARCHAR(20) | |
| UserId | INT | FOREIGN KEY → Users(Id) |

#### **OrderDetails**
| Column | Type | Constraints |
|--------|------|-------------|
| Id | INT | PRIMARY KEY, IDENTITY |
| ProductId | INT | Reference only |
| BookTitle | NVARCHAR(200) | NOT NULL |
| ProductImage | NVARCHAR(255) | |
| ProductPrice | DECIMAL(10,2) | NOT NULL |
| Quantity | INT | DEFAULT 1 |
| OrderId | INT | FOREIGN KEY → Orders(Id) |

#### **ProductInteractions**
| Column | Type | Constraints |
|--------|------|-------------|
| Id | INT | PRIMARY KEY, IDENTITY |
| UserId | INT | NOT NULL |
| ProductId | INT | NOT NULL |
| ActionType | NVARCHAR(10) | 'LIKE' or 'DISLIKE' |
| ActionDate | DATETIME | DEFAULT GETDATE() |

#### **ProductWishlist**
| Column | Type | Constraints |
|--------|------|-------------|
| Id | INT | PRIMARY KEY, IDENTITY |
| UserId | INT | FOREIGN KEY → Users(Id) |
| ProductId | INT | FOREIGN KEY → Products(Id) |
| | | UNIQUE(UserId, ProductId) |

---

## 🚀 Installation & Setup

### Prerequisites

- ✅ **Java JDK 21** or higher
- ✅ **Apache Maven 3.8+**
- ✅ **Microsoft SQL Server 2019+** (or SQL Server Express)
- ✅ **SQL Server Management Studio (SSMS)**
- ✅ **Eclipse IDE** (hoặc IDE khác hỗ trợ Java EE)
- ✅ **Apache Tomcat 10+** hoặc server tương thích Jakarta EE

### Step 1: Clone the Project

```bash
git clone <repository-url>
cd Asm
```

### Step 2: Setup Database

1. Mở **SQL Server Management Studio (SSMS)**
2. Kết nối đến SQL Server instance của bạn
3. Tạo database mới:
   ```sql
   CREATE DATABASE BookstoreDB;
   ```
4. Execute script `db/BookstoreDB.sql` để tạo tables và sample data:
   ```bash
   # Hoặc mở file db/BookstoreDB.sql trong SSMS và execute
   ```

### Step 3: Configure Database Connection

Mở file `src/main/resources/META-INF/persistence.xml` và cập nhật thông tin kết nối:

```xml
<property name="jakarta.persistence.jdbc.url" 
          value="jdbc:sqlserver://localhost:1433;databaseName=BookstoreDB;encrypt=false"/>
<property name="jakarta.persistence.jdbc.user" value="YOUR_USERNAME"/>
<property name="jakarta.persistence.jdbc.password" value="YOUR_PASSWORD"/>
```

### Step 4: Configure Email (Optional)

Nếu muốn sử dụng tính năng gửi email, cập nhật file `src/main/java/utils/EmailUtil.java`:

```java
private static final String SENDER_EMAIL = "your-email@gmail.com";
private static final String SENDER_PASSWORD = "your-app-password";
```

> **Lưu ý:** Sử dụng [App Password](https://support.google.com/accounts/answer/185833) cho Gmail, không phải mật khẩu thường.

### Step 5: Build Project

```bash
mvn clean install
```

### Step 6: Deploy to Server

#### **Option A: Eclipse IDE**
1. Import project vào Eclipse (File → Import → Maven → Existing Maven Projects)
2. Right-click project → Run As → Run on Server
3. Chọn Tomcat server và finish

#### **Option B: Manual Deployment**
1. Copy file `target/Asm-0.0.1-SNAPSHOT.war` vào thư mục `webapps/` của Tomcat
2. Start Tomcat server:
   ```bash
   # Windows
   catalina.bat run
   
   # Linux/Mac
   ./catalina.sh run
   ```

### Step 7: Access Application

Mở trình duyệt và truy cập:

- **User Interface:** `http://localhost:8080/Asm/home`
- **Admin Dashboard:** `http://localhost:8080/Asm/admin/dashboard`
- **Login Page:** `http://localhost:8080/Asm/login`

### Default Admin Account

```
Username: admin
Password: admin123
```

---

## 📡 API Documentation

### Product API Endpoints

Base URL: `/api/products`

#### **GET /api/products**
Lấy danh sách tất cả sản phẩm

**Response:**
```json
[
  {
    "id": 1,
    "bookTitle": "Clean Code",
    "author": "Robert C. Martin",
    "publisher": "Prentice Hall",
    "price": 350000.00,
    "stockQuantity": 50,
    "description": "A Handbook of Agile Software Craftsmanship",
    "imagePath": "images/cleancode.jpg",
    "viewCount": 150,
    "likeCount": 45,
    "dislikeCount": 2,
    "createdDate": "2025-01-15T10:30:00",
    "categoryName": "Technology",
    "categoryId": 1
  }
]
```

#### **GET /api/products/{id}**
Lấy chi tiết 1 sản phẩm

**Response:**
```json
{
  "id": 1,
  "bookTitle": "Clean Code",
  ...
}
```

#### **POST /api/products**
Tạo sản phẩm mới

**Request Body:**
```json
{
  "bookTitle": "New Book",
  "author": "Author Name",
  "publisher": "Publisher",
  "price": 250000,
  "stockQuantity": 30,
  "description": "Book description",
  "imagePath": "images/newbook.jpg",
  "categoryId": 1
}
```

#### **PUT /api/products/{id}**
Cập nhật sản phẩm

**Request Body:** (Tương tự POST)

#### **DELETE /api/products/{id}**
Xóa sản phẩm

**Response:**
```json
{
  "message": "Xóa sản phẩm thành công"
}
```

---

## 🎨 UI/UX Design Features

### Theme
- **Winter Theme** với gradient xanh dương (#2c5aa0, #5b9bd5)
- **Snowfall Animation** - Hiệu ứng tuyết rơi
- **Glassmorphism Cards** - Card trong suốt hiện đại
- **Smooth Transitions** - Chuyển động mượt mà

### Animations
- ✨ Fade-in effects cho products
- 🎯 Hover effects trên buttons & cards
- 📊 Animated charts với Chart.js
- 🔄 Loading states cho async operations

### Responsive Design
- 📱 Mobile-first approach
- 💻 Tablet & Desktop optimization
- 🖥️ Breakpoints: 576px, 768px, 992px, 1200px

---

## 🔒 Security Features

1. **Session Management**
   - HttpSession để lưu trữ user state
   - Session timeout configuration
   - Secure session cookies

2. **Authentication Filter**
   - Bảo vệ các route `/admin/*`
   - Redirect về login khi unauthorized
   - Role-based access control (USER/ADMIN)

3. **Input Validation**
   - Client-side validation với HTML5 & JavaScript
   - Server-side validation trong Servlet
   - JPQL parameters để tránh SQL injection

4. **Email Verification**
   - OTP 6 số ngẫu nhiên
   - Expiry time 5 phút
   - Session-based verification

---

## 📊 Business Logic Highlights

### Like/Dislike System
```
1. User click "Like" button
2. Check if user already interacted:
   - If NO → Create new interaction, increment likeCount
   - If YES (same action) → Remove interaction, decrement count
   - If YES (different action) → Block (must remove first)
3. Return updated counts to frontend
4. Update UI in real-time (no page reload)
```

### Wishlist → Checkout Flow
```
1. User browses products
2. Click "Add to Wishlist" → ProductWishlist record created
3. Go to Wishlist page → View all saved products
4. Select multiple items → Checkbox selection
5. Click "Checkout" → Forward to checkout page with selected items
6. Fill recipient info → Submit order
7. Create Order + OrderDetails records
8. Remove purchased items from Wishlist
9. Show success popup → Redirect to home
```

### View Count Tracking
```
1. User clicks on product card
2. ProductDetailServlet intercepts request
3. JPQL UPDATE to increment viewCount
4. Display product details with updated count
5. Show related products from same category
```

---

## 🧪 Testing

### Manual Testing Checklist

#### User Flow
- [ ] Đăng ký tài khoản với OTP verification
- [ ] Đăng nhập/Đăng xuất
- [ ] Tìm kiếm sách theo tên/tác giả
- [ ] Xem chi tiết sản phẩm
- [ ] Like/Dislike sản phẩm
- [ ] Thêm/Xóa sản phẩm khỏi wishlist
- [ ] Checkout và tạo đơn hàng
- [ ] Xem lịch sử đơn hàng
- [ ] Cập nhật profile
- [ ] Đổi mật khẩu

#### Admin Flow
- [ ] Xem dashboard với charts
- [ ] Quản lý users (CRUD)
- [ ] Quản lý categories (CRUD)
- [ ] Quản lý products (CRUD + upload image)
- [ ] Xem và cập nhật đơn hàng
- [ ] View order details

---

## 🐛 Known Issues & Limitations

1. **Security:**
   - ⚠️ Passwords stored in plain text (should use BCrypt hashing)
   - ⚠️ Email credentials hard-coded (should use environment variables)
   - ⚠️ No CSRF protection

2. **Performance:**
   - ⚠️ No pagination for large product lists
   - ⚠️ Lazy loading có thể gây N+1 query problem
   - ⚠️ No caching mechanism

3. **Features:**
   - ⚠️ No shopping cart (direct checkout from wishlist)
   - ⚠️ No payment integration
   - ⚠️ No product reviews/ratings
   - ⚠️ No inventory management alerts

---

## 🚧 Future Enhancements

### Planned Features
- [ ] 🔐 Password hashing với BCrypt
- [ ] 📄 Pagination cho danh sách sản phẩm
- [ ] 🛒 Shopping Cart functionality
- [ ] 💳 Payment gateway integration (VNPay, MoMo)
- [ ] ⭐ Product reviews & star ratings
- [ ] 🔔 Email notifications cho order status
- [ ] 📈 Advanced analytics cho admin
- [ ] 🌍 Multi-language support (i18n)
- [ ] 🔍 Advanced search với filters
- [ ] 📱 Mobile app (React Native)

### Technical Improvements
- [ ] Add logging framework (Log4j2, SLF4J)
- [ ] Implement caching (Redis/Ehcache)
- [ ] Add unit tests (JUnit 5)
- [ ] Integration tests (Selenium)
- [ ] Docker containerization
- [ ] CI/CD pipeline (Jenkins/GitHub Actions)
- [ ] API authentication (JWT)
- [ ] WebSocket for real-time notifications

---

## 📝 Code Statistics

| Component | Count | Lines of Code |
|-----------|-------|---------------|
| Servlets | 22 | ~5,000 |
| Entities | 7 | ~500 |
| JSP Pages | 14 | ~8,000 |
| Utility Classes | 3 | ~200 |
| **Total** | **46 files** | **~15,000+ LOC** |

---

## 👨‍💻 Development Team

- **Developer:** [Your Name]
- **Course:** Java Web Development
- **Duration:** 2-3 weeks
- **Year:** 2025

---

## 📄 License

This project is developed for educational purposes as part of a Java Web Development course.

---

## 🙏 Acknowledgments

- **Eclipse IDE** - Development environment
- **Stack Overflow** - Problem solving
- **Bootstrap Team** - UI framework
- **Hibernate Team** - ORM framework
- **Chart.js** - Data visualization library

---

## 📞 Support

For questions or issues, please contact:
- Email: [your-email@example.com]
- GitHub: [your-github-profile]

---

## 📚 Documentation References

- [Jakarta EE Documentation](https://jakarta.ee/)
- [Hibernate ORM Guide](https://hibernate.org/orm/documentation/)
- [Bootstrap 5 Docs](https://getbootstrap.com/docs/5.0/)
- [Chart.js Documentation](https://www.chartjs.org/docs/)
- [SQL Server T-SQL Reference](https://docs.microsoft.com/en-us/sql/t-sql/)

---

<div align="center">

**Made with ❤️ and ☕ by Java Developers**

⭐ If you find this project helpful, please give it a star!

</div>
