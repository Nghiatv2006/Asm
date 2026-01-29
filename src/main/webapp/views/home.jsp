<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Trang Chủ - Bookstore</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
body {
    background: linear-gradient(135deg, #4a90e2 0%, #7ec8e3 100%);
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    position: relative;
    overflow-x: hidden;
}

/* Hiệu ứng tuyết rơi */
.snowflake {
    position: fixed;
    top: -10px;
    z-index: 9999;
    color: #fff;
    font-size: 1em;
    font-family: Arial, sans-serif;
    text-shadow: 0 0 5px #000;
    pointer-events: none;
    animation: fall linear infinite;
}

@keyframes fall {
    to {
        transform: translateY(100vh);
    }
}

/* Navbar - Theme đông */
.navbar {
    background: linear-gradient(135deg, #2c5aa0 0%, #1e3a5f 100%);
    padding: 5px 0;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 1000;
}

.navbar-brand {
    color: white !important;
    font-weight: bold;
    font-size: 28px;
}

.navbar-brand i {
    margin-right: 10px;
}

.navbar-nav .nav-link {
    color: white !important;
    margin: 0 10px;
    transition: all 0.3s;
    font-size: 16px;
}

.navbar-nav .nav-link:hover {
    transform: translateY(-2px);
    text-shadow: 0 0 10px rgba(255,255,255,0.8);
}

/* Hero Section - Mùa đông */
.hero-section {
    background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
    color: white;
    padding: 80px 0;
    margin-bottom: 40px;
    text-align: center;
    margin-top: 60px;
}

.hero-section h1 {
    font-weight: bold;
    margin-bottom: 20px;
    font-size: 48px;
    text-shadow: 2px 2px 8px rgba(0,0,0,0.3);
}

.hero-section p {
    font-size: 20px;
    margin-bottom: 30px;
}

/* Search Bar - Đông */
.search-section {
    margin: -30px auto 40px;
    max-width: 900px;
    position: relative;
    z-index: 10;
}

.search-box {
    background: white;
    border-radius: 50px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    padding: 10px;
    display: flex;
    align-items: center;
}

.search-box input {
    border: none;
    outline: none;
    flex: 1;
    padding: 15px 20px;
    font-size: 16px;
}

.search-type {
    display: flex;
    gap: 15px;
    padding: 0 15px;
    border-left: 2px solid #e0e0e0;
}

.search-type label {
    display: flex;
    align-items: center;
    cursor: pointer;
    font-size: 14px;
    color: #666;
}

.search-type input[type="radio"] {
    margin-right: 5px;
}

.search-box button {
    background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
    border: none;
    color: white;
    padding: 15px 30px;
    border-radius: 50px;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.3s;
}

.search-box button:hover {
    transform: scale(1.05);
    box-shadow: 0 5px 15px rgba(44, 90, 160, 0.6);
}

/* Category Pills - Đông */
.category-pills {
    display: flex;
    gap: 15px;
    margin-bottom: 30px;
    flex-wrap: wrap;
    justify-content: center;
}

.category-pill {
    padding: 12px 25px;
    border-radius: 50px;
    border: 2px solid #d0e8f2;
    background: white;
    color: #2c5aa0;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s;
    text-decoration: none;
    display: inline-block;
}

.category-pill:hover {
    border-color: #2c5aa0;
    color: #2c5aa0;
    transform: translateY(-3px);
    box-shadow: 0 5px 15px rgba(44, 90, 160, 0.3);
}

.category-pill.active {
    background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
    border-color: #2c5aa0;
    color: white;
    box-shadow: 0 5px 20px rgba(44, 90, 160, 0.5);
}

.category-pill .badge {
    background: rgba(0, 0, 0, 0.2); /* Tối hơn, dễ nhìn */
    color: #333; /* Chữ đen */
    padding: 4px 10px;
    border-radius: 10px;
    font-size: 13px;
    font-weight: bold;
    margin-left: 8px;
}

.category-pill.active .badge {
    background: rgba(255, 255, 255, 0.8); /* Trắng sáng */
    color: #2c5aa0; /* Chữ xanh */
}


/* Product Card - Đông với hiệu ứng đóng băng */
.product-card {
    border: none;
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
    transition: all 0.3s;
    margin-bottom: 30px;
    background: white;
}

@keyframes sparkle {
    0%, 100% { box-shadow: 0 25px 50px rgba(44, 90, 160, 0.8), 0 0 50px rgba(91, 155, 213, 1); }
    50% { box-shadow: 0 25px 50px rgba(44, 90, 160, 0.8), 0 0 80px rgba(135, 206, 250, 1); }
}

.product-card:hover {
    transform: translateY(-7px) scale(1);
    border: 5px solid #5b9bd5;
    filter: brightness(1.2);
    animation: sparkle 1s ease-in-out infinite;
}



.product-image {
    height: 320px;
    object-fit: cover;
    width: 100%;
}

.product-body {
    padding: 20px;
}

.product-title {
    font-weight: bold;
    font-size: 18px;
    margin-bottom: 8px;
    color: #333;
    height: 50px;
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}

.product-author {
    color: #666;
    font-size: 14px;
    margin-bottom: 12px;
}

.product-price {
    color: #2c5aa0;
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 15px;
}

.btn-view {
    background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
    border: none;
    border-radius: 10px;
    color: white;
    padding: 12px 20px;
    transition: all 0.3s;
    width: 100%;
    font-weight: bold;
}

.btn-view:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(44, 90, 160, 0.5);
    color: white;
}

/* Footer - Đông */
.footer {
    background: #1e3a5f;
    color: white;
    padding: 40px 0;
    margin-top: 60px;
}

.footer h5 {
    font-weight: bold;
    margin-bottom: 20px;
}

.footer p {
    color: #b8d4e8;
}

/* Empty State */
.empty-state {
    text-align: center;
    padding: 60px 20px;
}

.empty-state i {
    font-size: 80px;
    color: #ccc;
    margin-bottom: 20px;
}

.empty-state h3 {
    color: #666;
    margin-bottom: 10px;
}

.empty-state p {
    color: #999;
}

.testimonials-section {
    background: transparent; /* TRONG SUỐT - KHÔNG CÓ NỀN */
    overflow: hidden;
    padding: 60px 0;
}

.testimonials-section h2 {
    color: white;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
}


.testimonials-slider {
    overflow: hidden;
    position: relative;
    width: 100%;
}

.testimonial-track {
    display: flex;
    gap: 20px;
    animation: scroll 15s linear infinite;
}

.testimonial-card {
    min-width: 350px;
    background: white;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
    text-align: center;
    flex-shrink: 0;
}

.testimonial-card .stars {
    font-size: 24px;
    margin-bottom: 15px;
}

.testimonial-card p {
    font-style: italic;
    color: #555;
    margin-bottom: 15px;
}

.testimonial-card strong {
    color: #2c5aa0;
}

@keyframes scroll {
    0% {
        transform: translateX(0);
    }
    100% {
        transform: translateX(-50%);
    }
}


/* BỎ HOVER PAUSE */
/* .testimonial-track:hover {
    animation-play-state: paused;
} */

</style>
</head>

<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="home"> <i class="fas fa-book"></i> Bookstore </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link active" href="home"><i class="fas fa-home"></i> Trang Chủ</a></li>
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedInUser}">
                        <li class="nav-item"><a class="nav-link" href="wishlist"><i class="fas fa-heart"></i> Yêu Thích / Giỏ Hàng</a></li>
                        <li class="nav-item"><a class="nav-link" href="profile"><i class="fas fa-user"></i> ${sessionScope.username}</a></li>
                        <c:if test="${sessionScope.role == 'ADMIN'}">
                            <li class="nav-item"><a class="nav-link" href="admin/dashboard"><i class="fas fa-cog"></i> Quản Trị</a></li>
                        </c:if>
                        <li class="nav-item"><a class="nav-link" href="#" onclick="confirmLogout(event)"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item"><a class="nav-link" href="login"><i class="fas fa-sign-in-alt"></i> Đăng Nhập</a></li>
                        <li class="nav-item"><a class="nav-link" href="register"><i class="fas fa-user-plus"></i> Đăng Ký</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<div class="hero-section">
    <div class="container">
        <h1>❄️ <i class="fas fa-book-open"></i> Chào Mừng Đến Bookstore! ❄️</h1>
        <p class="lead">Khám phá hàng ngàn cuốn sách hay nhất</p>
    </div>
</div>

<!-- Search Bar -->
<div class="container">
    <div class="search-section">
        <form action="home" method="get" class="search-box">
            <input type="text" name="search" placeholder="Tìm kiếm sách..." value="${searchQuery != null ? searchQuery : ''}">
            <div class="search-type">
                <label><input type="radio" name="searchType" value="name" ${searchType == 'name' || searchType == null ? 'checked' : ''}> Tên sách</label>
                <label><input type="radio" name="searchType" value="author" ${searchType == 'author' ? 'checked' : ''}> Tác giả</label>
            </div>
            <button type="submit"><i class="fas fa-search"></i> Tìm Kiếm</button>
        </form>
    </div>
</div>

<!-- Category Pills -->
<div class="container">
    <div class="category-pills">
        <a href="home" class="category-pill ${selectedCategoryId == null || selectedCategoryId == '' ? 'active' : ''}">
            <i class="fas fa-fire"></i> Tất Cả <span class="badge">${totalCount}</span>
            
        </a>
        <c:forEach var="category" items="${categories}">
            <a href="home?categoryId=${category.id}" class="category-pill ${selectedCategoryId == category.id.toString() ? 'active' : ''}">
                ${category.categoryName} <span class="badge">${categoryCountMap[category.id]}</span>
            </a>
        </c:forEach>
    </div>
</div>

<!-- Products Section -->
<div class="container">
    <h2 class="mb-4">
        <c:choose>
            <c:when test="${searchQuery != null && !searchQuery.isEmpty()}">
                <i class="fas fa-search"></i> Kết quả tìm kiếm 
                <c:choose>
                    <c:when test="${searchType == 'author'}">(theo tác giả): "<strong>${searchQuery}</strong>"</c:when>
                    <c:otherwise>(theo tên sách): "<strong>${searchQuery}</strong>"</c:otherwise>
                </c:choose>
            </c:when>
            <c:when test="${selectedCategoryId != null && !selectedCategoryId.isEmpty()}">
                <i class="fas fa-filter"></i> Danh mục đã chọn
            </c:when>
            <c:otherwise>
                <i class="fas fa-fire text-danger"></i> Tất Cả Sản Phẩm
            </c:otherwise>
        </c:choose>
        <span class="badge bg-primary">${products.size()}</span>
    </h2>

    <c:choose>
        <c:when test="${products.size() > 0}">
            <div class="row">
                <c:forEach var="product" items="${products}">
                    <div class="col-md-4 col-lg-4">
                        <div class="card product-card">
                            <img src="${pageContext.request.contextPath}${product.imagePath}" class="product-image" alt="${product.bookTitle}"
                                 onerror="this.src='https://via.placeholder.com/300x400?text=No+Image'">
                            <div class="product-body">
                                <h5 class="product-title">${product.bookTitle}</h5>
                                <p class="product-author"><i class="fas fa-user-edit"></i> ${product.author}</p>
                                <p class="product-price"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0"/> đ</p>
                                <a href="product-detail?id=${product.id}" class="btn btn-view"><i class="fas fa-eye"></i> Xem Chi Tiết</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <i class="fas fa-book-open"></i>
                <h3>Không tìm thấy sản phẩm nào</h3>
                <p>Vui lòng thử lại với từ khóa khác hoặc chọn danh mục khác</p>
                <a href="home" class="btn btn-primary mt-3"><i class="fas fa-home"></i> Về Trang Chủ</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- ĐÁNH GIÁ KHÁCH HÀNG (AUTO SLIDER) -->
<section class="testimonials-section py-5">
    <div class="container">
        <h2 class="text-center mb-5">💬 Khách hàng nói gì về chúng tôi</h2>
        <div class="testimonials-slider">
            <div class="testimonial-track">
                <!-- Review 1 -->
                <div class="testimonial-card">
                    <div class="stars">⭐⭐⭐⭐⭐</div>
                    <p>"Sách đẹp, giao hàng nhanh. Mình rất hài lòng với dịch vụ!"</p>
                    <strong>- Nguyễn Văn A</strong>
                </div>
                
                <!-- Review 2 -->
                <div class="testimonial-card">
                    <div class="stars">⭐⭐⭐⭐⭐</div>
                    <p>"Giá cả hợp lý, đóng gói cẩn thận. Sẽ ủng hộ shop lâu dài!"</p>
                    <strong>- Trần Thị B</strong>
                </div>
                
                <!-- Review 3 -->
                <div class="testimonial-card">
                    <div class="stars">⭐⭐⭐⭐⭐</div>
                    <p>"Chất lượng sách tốt, không bị rách hay nhàu nát. Tuyệt vời!"</p>
                    <strong>- Lê Văn C</strong>
                </div>
                
                <!-- Review 4 -->
                <div class="testimonial-card">
                    <div class="stars">⭐⭐⭐⭐</div>
                    <p>"Dịch vụ chăm sóc khách hàng nhiệt tình. Nhân viên tư vấn rất tốt!"</p>
                    <strong>- Phạm Thị D</strong>
                </div>
                
                <!-- Review 5 -->
                <div class="testimonial-card">
                    <div class="stars">⭐⭐⭐⭐⭐</div>
                    <p>"Giao đúng hạn, sách chính hãng 100%. Rất đáng tin cậy!"</p>
                    <strong>- Hoàng Văn E</strong>
                </div>
                
                <!-- DUPLICATE để vòng lặp mượt -->
                <div class="testimonial-card">
                    <div class="stars">⭐⭐⭐⭐⭐</div>
                    <p>"Sách đẹp, giao hàng nhanh. Mình rất hài lòng với dịch vụ!"</p>
                    <strong>- Nguyễn Văn A</strong>
                </div>
                
                <div class="testimonial-card">
                    <div class="stars">⭐⭐⭐⭐⭐</div>
                    <p>"Giá cả hợp lý, đóng gói cẩn thận. Sẽ ủng hộ shop lâu dài!"</p>
                    <strong>- Trần Thị B</strong>
                </div>
            </div>
        </div>
    </div>
</section>


<!-- Footer -->
<div class="footer">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h5><i class="fas fa-book"></i> Bookstore</h5>
                <p>Cửa hàng sách trực tuyến uy tín, cung cấp hàng ngàn đầu sách chất lượng.</p>
            </div>
            <div class="col-md-3">
                <h5>Liên Hệ</h5>
                <p><i class="fas fa-phone"></i> 0901234567</p>
                <p><i class="fas fa-envelope"></i> info@bookstore.com</p>
            </div>
            <div class="col-md-3">
                <h5>Theo Dõi</h5>
                <p>
                    <a href="#" class="text-white me-3"><i class="fab fa-facebook fa-2x"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-instagram fa-2x"></i></a>
                    <a href="#" class="text-white"><i class="fab fa-youtube fa-2x"></i></a>
                </p>
            </div>
        </div>
        <hr style="border-color: #7f8c8d;">
        <p class="text-center mb-0">&copy; 2025 Bookstore. All rights reserved.</p>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Popup đăng nhập thành công -->
<script>
<% 
String loginSuccessMessage = (String) session.getAttribute("loginSuccessMessage");
if (loginSuccessMessage != null) { 
    session.removeAttribute("loginSuccessMessage");
%>
    Swal.fire({
        icon: 'success',
        title: 'Đăng Nhập Thành Công!',
        text: '<%= loginSuccessMessage %>',
        confirmButtonText: 'OK',
        confirmButtonColor: '#2c5aa0',
        timer: 2000
    });
<% } %>
</script>

<!-- Xác nhận đăng xuất -->
<script>
function confirmLogout(event) {
    event.preventDefault();
    Swal.fire({
        icon: 'question',
        title: 'Xác nhận đăng xuất',
        text: 'Bạn có chắc chắn muốn đăng xuất không?',
        showCancelButton: true,
        confirmButtonText: '<i class="fas fa-sign-out-alt"></i> Đăng Xuất',
        cancelButtonText: 'Hủy',
        confirmButtonColor: '#dc3545',
        cancelButtonColor: '#6c757d',
        reverseButtons: true
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                icon: 'success',
                title: 'Đã đăng xuất!',
                text: 'Hẹn gặp lại bạn!',
                timer: 1500,
                showConfirmButton: false
            }).then(() => {
                window.location.href = 'logout';
            });
        }
    });
}
</script>

<!-- Script giữ vị trí scroll -->
<script>
document.querySelectorAll('.category-pill').forEach(pill => {
    pill.addEventListener('click', function() {
        sessionStorage.setItem('scrollPos', window.scrollY);
    });
});

window.addEventListener('load', function() {
    const scrollPos = sessionStorage.getItem('scrollPos');
    if (scrollPos) {
        window.scrollTo(0, parseInt(scrollPos));
        sessionStorage.removeItem('scrollPos');
    }
});
</script>

<!-- Hiệu ứng tuyết rơi (dày + chậm + to) -->
<script>
function createSnowflake() {
    const snowflake = document.createElement('div');
    snowflake.classList.add('snowflake');
    snowflake.innerHTML = '❄';
    snowflake.style.left = Math.random() * window.innerWidth + 'px';
    snowflake.style.animationDuration = Math.random() * 5 + 4 + 's'; // Rơi chậm hơn (4-9s)
    snowflake.style.opacity = Math.random() * 0.7 + 0.3; // Độ mờ 0.3-1.0
    snowflake.style.fontSize = Math.random() * 25 + 18 + 'px'; // To hơn (18-43px)
    
    document.body.appendChild(snowflake);
    
    setTimeout(() => {
        snowflake.remove();
    }, 9000);
}

setInterval(createSnowflake, 180); // Sinh tuyết dày hơn (mỗi 100ms)
</script>
</body>
</html>
