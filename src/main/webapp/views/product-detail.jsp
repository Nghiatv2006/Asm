<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.bookTitle} - Bookstore</title>
    
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
        
        /* Product Detail Container */
        .product-detail-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 5px 20px rgba(44, 90, 160, 0.2);
            padding: 40px;
            margin: 100px 0 40px 0;
        }
        
        .product-image-wrapper {
            text-align: center;
            padding: 20px;
        }
        
        .product-image-large {
            max-width: 100%;
            height: auto;
            max-height: 500px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(44, 90, 160, 0.3);
            transition: transform 0.3s;
        }
        
        .product-image-large:hover {
            transform: scale(1.05);
            box-shadow: 0 15px 40px rgba(44, 90, 160, 0.5);
        }
        
        .product-title {
            font-size: 32px;
            font-weight: bold;
            color: #1e3a5f;
            margin-bottom: 15px;
        }
        
        .product-author {
            font-size: 18px;
            color: #2c5aa0;
            margin-bottom: 10px;
        }
        
        .product-publisher {
            font-size: 16px;
            color: #5b9bd5;
            margin-bottom: 20px;
        }
        
        .product-price {
            font-size: 36px;
            font-weight: bold;
            color: #2c5aa0;
            margin-bottom: 20px;
        }
        
        .product-category {
            display: inline-block;
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            color: white;
            padding: 8px 20px;
            border-radius: 50px;
            font-size: 14px;
            margin-bottom: 20px;
        }
        
        .product-stats {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .stat-item {
            background: linear-gradient(145deg, #e3f2fd 0%, #d0e8f2 100%);
            padding: 10px 20px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 2px solid #b8d4e8;
        }
        
        .stat-item i {
            color: #2c5aa0;
        }
        
        .product-description {
            margin: 30px 0;
            line-height: 1.8;
            color: #555;
        }
        
        .product-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        
        .btn-action {
            padding: 15px 30px;
            border-radius: 10px;
            font-weight: bold;
            border: none;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .btn-like {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        
        .btn-like:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.5);
        }
        
        .btn-dislike {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }
        
        .btn-dislike:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.5);
        }
        
        .btn-wishlist {
            background: linear-gradient(135deg, #ff6b6b 0%, #ff5252 100%);
            color: white;
        }
        
        .btn-wishlist:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(255, 107, 107, 0.5);
        }
        
        .btn-share {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            color: white;
        }
        
        .btn-share:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(44, 90, 160, 0.5);
        }
        
        /* Related Products */
        .related-products {
            margin-top: 60px;
        }
        
        .related-products h3 {
            font-weight: bold;
            margin-bottom: 30px;
            color: #1e3a5f;
        }
        
        .related-card {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(44, 90, 160, 0.15);
            transition: all 0.3s;
            background: white;
        }
        
        .related-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 15px 35px rgba(44, 90, 160, 0.4), 0 0 30px rgba(91, 155, 213, 0.6);
            border: 3px solid #5b9bd5;
        }
        
        .related-image {
            height: 250px;
            object-fit: cover;
            width: 100%;
        }
        
        .related-body {
            padding: 15px;
        }
        
        .related-title {
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 8px;
            color: #333;
            height: 40px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        
        .related-price {
            color: #2c5aa0;
            font-size: 18px;
            font-weight: bold;
        }
        
        .breadcrumb {
            background: transparent;
            padding: 80px 0 20px 0;
        }
        
        .breadcrumb-item a {
            color: #2c5aa0;
            text-decoration: none;
            font-weight: 600;
        }
        
        .breadcrumb-item.active {
            color: #1e3a5f;
        }
    </style>
</head>

<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="home">
                <i class="fas fa-book"></i> Bookstore
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="home"><i class="fas fa-home"></i> Trang Chủ</a>
                    </li>
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <li class="nav-item">
                                <a class="nav-link" href="wishlist"><i class="fas fa-heart"></i> Yêu Thích / Giỏ hàng</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="profile"><i class="fas fa-user"></i> ${sessionScope.username}</a>
                            </li>
                            <c:if test="${sessionScope.role == 'ADMIN'}">
                                <li class="nav-item">
                                    <a class="nav-link" href="admin/dashboard"><i class="fas fa-cog"></i> Quản Trị</a>
                                </li>
                            </c:if>
                            <li class="nav-item">
                                <a class="nav-link" href="#" onclick="confirmLogout(event)">
                                    <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="login"><i class="fas fa-sign-in-alt"></i> Đăng Nhập</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="register"><i class="fas fa-user-plus"></i> Đăng Ký</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Breadcrumb -->
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="home"><i class="fas fa-home"></i> Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="home?categoryId=${product.category.id}">${product.category.categoryName}</a></li>
                <li class="breadcrumb-item active">${product.bookTitle}</li>
            </ol>
        </nav>
    </div>
    
    <!-- Product Detail -->
    <div class="container">
        <div class="product-detail-container">
            <div class="row">
                <!-- Product Image -->
                <div class="col-md-5">
                    <div class="product-image-wrapper">
                        <img src="${pageContext.request.contextPath}${product.imagePath}" 
                             class="product-image-large" alt="${product.bookTitle}"
                             onerror="this.src='https://via.placeholder.com/400x600?text=No+Image'">
                    </div>
                </div>
                
                <!-- Product Info -->
                <div class="col-md-7">
                    <h1 class="product-title">${product.bookTitle}</h1>
                    
                    <p class="product-author">
                        <i class="fas fa-user-edit"></i> <strong>Tác giả:</strong> ${product.author}
                    </p>
                    
                    <p class="product-publisher">
                        <i class="fas fa-building"></i> <strong>Nhà xuất bản:</strong> ${product.publisher != null ? product.publisher : 'Đang cập nhật'}
                    </p>
                    
                    <div class="product-category">
                        <i class="fas fa-tag"></i> ${product.category.categoryName}
                    </div>
                    
                    <div class="product-price">
                        <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0"/> đ
                    </div>
                    
                    <!-- Product Stats -->
                    <div class="product-stats">
                        <div class="stat-item">
                            <i class="fas fa-eye"></i>
                            <span><strong>${product.viewCount}</strong> lượt xem</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-thumbs-up"></i>
                            <span><strong id="likeCountDisplay">${product.likeCount}</strong> thích</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-thumbs-down"></i>
                            <span><strong id="dislikeCountDisplay">${product.dislikeCount}</strong> không thích</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-boxes"></i>
                            <span><strong>${product.stockQuantity}</strong> sản phẩm còn lại</span>
                        </div>
                    </div>
                    
                    <!-- Product Description -->
                    <div class="product-description">
                        <h5><i class="fas fa-info-circle"></i> Mô tả sản phẩm</h5>
                        <p>${product.description != null ? product.description : 'Chưa có mô tả chi tiết cho sản phẩm này.'}</p>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="product-actions">
                        <button class="btn btn-action btn-like" onclick="handleLike()">
                            <i class="fas fa-thumbs-up"></i> Thích
                        </button>
                        <button class="btn btn-action btn-dislike" onclick="handleDislike()">
                            <i class="fas fa-thumbs-down"></i> Không Thích
                        </button>
                        <button class="btn btn-action btn-wishlist" onclick="handleWishlist()">
                            <i class="fas fa-heart"></i> Yêu Thích
                        </button>
                        <button class="btn btn-action btn-share" onclick="handleShare()">
                            <i class="fas fa-share-alt"></i> Chia Sẻ
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Related Products -->
        <c:if test="${relatedProducts.size() > 0}">
            <div class="related-products">
                <h3><i class="fas fa-book-reader"></i> Sản Phẩm Liên Quan</h3>
                <div class="row">
                    <c:forEach var="related" items="${relatedProducts}">
                        <div class="col-md-4">
                            <div class="card related-card">
                                <img src="${pageContext.request.contextPath}${related.imagePath}" 
                                     class="related-image" alt="${related.bookTitle}"
                                     onerror="this.src='https://via.placeholder.com/300x400?text=No+Image'">
                                <div class="related-body">
                                    <h6 class="related-title">${related.bookTitle}</h6>
                                    <p class="related-price">
                                        <fmt:formatNumber value="${related.price}" type="number" maxFractionDigits="0"/> đ
                                    </p>
                                    <a href="product-detail?id=${related.id}" class="btn btn-primary btn-sm w-100">
                                        <i class="fas fa-eye"></i> Xem Chi Tiết
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Script xử lý Like/Dislike -->
    <script>
        const isLoggedIn = ${not empty sessionScope.loggedInUser};
        const productId = ${product.id};
        let currentAction = ""; 
        
        window.addEventListener('DOMContentLoaded', function() {
            if (isLoggedIn) {
                checkUserReaction();
            }
        });
        
        function checkUserReaction() {
            fetch('check-reaction?productId=' + productId)
                .then(response => response.json())
                .then(data => {
                    if (data.hasReaction) {
                        currentAction = data.actionType;
                        updateButtonStates();
                    }
                })
                .catch(error => console.error('Error:', error));
        }
        
        function handleLike() {
            if (!isLoggedIn) {
                showLoginRequired();
                return;
            }
            
            fetch('like-product', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'productId=' + productId + '&action=like'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateLikeDislikeCounts(data.likeCount, data.dislikeCount);
                    currentAction = data.currentAction;
                    updateButtonStates();
                    
                    Swal.fire({
                        icon: 'success',
                        title: data.message,
                        timer: 1500,
                        showConfirmButton: false
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: data.message,
                        timer: 2000,
                        showConfirmButton: false
                    });
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi!',
                    text: 'Không thể kết nối với server',
                    confirmButtonColor: '#d33'
                });
            });
        }
        
        function handleDislike() {
            if (!isLoggedIn) {
                showLoginRequired();
                return;
            }
            
            fetch('like-product', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'productId=' + productId + '&action=dislike'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateLikeDislikeCounts(data.likeCount, data.dislikeCount);
                    currentAction = data.currentAction;
                    updateButtonStates();
                    
                    Swal.fire({
                        icon: 'success',
                        title: data.message,
                        timer: 1500,
                        showConfirmButton: false
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: data.message,
                        timer: 2000,
                        showConfirmButton: false
                    });
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi!',
                    text: 'Không thể kết nối với server',
                    confirmButtonColor: '#d33'
                });
            });
        }
        
        function updateLikeDislikeCounts(likeCount, dislikeCount) {
            const likeElement = document.getElementById('likeCountDisplay');
            const dislikeElement = document.getElementById('dislikeCountDisplay');
            
            if (likeElement) {
                likeElement.textContent = likeCount;
            }
            
            if (dislikeElement) {
                dislikeElement.textContent = dislikeCount;
            }
        }
        
        function updateButtonStates() {
            const likeBtn = document.querySelector('.btn-like');
            const dislikeBtn = document.querySelector('.btn-dislike');
            
            if (currentAction === "LIKE") {
                likeBtn.style.opacity = '1';
                likeBtn.style.filter = 'brightness(0.8)';
                likeBtn.innerHTML = '<i class="fas fa-thumbs-up"></i> Đã Thích';
                
                dislikeBtn.disabled = true;
                dislikeBtn.style.opacity = '0.5';
                dislikeBtn.style.cursor = 'not-allowed';
                
            } else if (currentAction === "DISLIKE") {
                dislikeBtn.style.opacity = '1';
                dislikeBtn.style.filter = 'brightness(0.8)';
                dislikeBtn.innerHTML = '<i class="fas fa-thumbs-down"></i> Đã Đánh Giá';
                
                likeBtn.disabled = true;
                likeBtn.style.opacity = '0.5';
                likeBtn.style.cursor = 'not-allowed';
                
            } else {
                likeBtn.disabled = false;
                likeBtn.style.opacity = '1';
                likeBtn.style.filter = 'none';
                likeBtn.style.cursor = 'pointer';
                likeBtn.innerHTML = '<i class="fas fa-thumbs-up"></i> Thích';
                
                dislikeBtn.disabled = false;
                dislikeBtn.style.opacity = '1';
                dislikeBtn.style.filter = 'none';
                dislikeBtn.style.cursor = 'pointer';
                dislikeBtn.innerHTML = '<i class="fas fa-thumbs-down"></i> Không Thích';
            }
        }
        
        function handleWishlist() {
            if (!isLoggedIn) {
                showLoginRequired();
                return;
            }
            fetch('add-to-wishlist', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'productId=' + productId
            })
            .then(response => response.json())
            .then(data => {
                Swal.fire({
                    icon: data.success ? 'success' : 'warning',
                    title: data.message,
                    timer: 1800,
                    showConfirmButton: false
                });
            })
            .catch(error => {
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi!',
                    text: 'Không thể kết nối với server',
                    confirmButtonColor: '#d33'
                });
            });
        }

        
        function handleShare() {
            if (!isLoggedIn) {
                showLoginRequired();
                return;
            }
            Swal.fire({
                title: 'Chia sẻ qua Email',
                input: 'email',
                inputPlaceholder: 'Nhập email bạn muốn chia sẻ',
                showCancelButton: true,
                confirmButtonText: 'Gửi',
                cancelButtonText: 'Hủy',
                confirmButtonColor: '#2c5aa0',
                inputValidator: (value) => {
                    if (!value) {
                        return 'Vui lòng nhập email!';
                    }
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch('share-product', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'productId=' + productId + '&recipientEmail=' + encodeURIComponent(result.value)
                    })
                    .then(response => response.json())
                    .then(data => {
                        Swal.fire({
                            icon: data.success ? 'success' : 'error',
                            title: data.message,
                            timer: 2000,
                            showConfirmButton: false
                        });
                    })
                    .catch(error => {
                        Swal.fire({
                            icon: 'error',
                            title: 'Lỗi kết nối!',
                            text: 'Không thể gửi email',
                            confirmButtonColor: '#d33'
                        });
                    });
                }
            });
        }
        
        function showLoginRequired() {
            Swal.fire({
                icon: 'warning',
                title: 'Yêu cầu đăng nhập',
                text: 'Bạn cần đăng nhập để sử dụng chức năng này!',
                showCancelButton: true,
                confirmButtonText: 'Đăng nhập ngay',
                cancelButtonText: 'Để sau',
                confirmButtonColor: '#2c5aa0',
                cancelButtonColor: '#999'
            }).then((result) => {
                if (result.isConfirmed) {
                    const currentUrl = window.location.href;
                    window.location.href = 'login?redirect=' + encodeURIComponent(currentUrl);
                }
            });
        }
        
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
    
    <!-- Hiệu ứng tuyết rơi -->
    <script>
        function createSnowflake() {
            const snowflake = document.createElement('div');
            snowflake.classList.add('snowflake');
            snowflake.innerHTML = '❄';
            snowflake.style.left = Math.random() * window.innerWidth + 'px';
            snowflake.style.animationDuration = Math.random() * 5 + 4 + 's';
            snowflake.style.opacity = Math.random() * 0.7 + 0.3;
            snowflake.style.fontSize = Math.random() * 25 + 18 + 'px';
            
            document.body.appendChild(snowflake);
            
            setTimeout(() => {
                snowflake.remove();
            }, 9000);
        }
        
        setInterval(createSnowflake, 180);
    </script>
</body>
</html>
