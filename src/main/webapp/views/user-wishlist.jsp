<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sản phẩm yêu thích</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            background: linear-gradient(135deg, #4a90e2 0%, #7ec8e3 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            position: relative;
            overflow-x: hidden;
            min-height: 100vh;
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
    margin-bottom: 0;
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

.navbar-nav .nav-link:hover, .navbar-nav .nav-link.active {
    transform: translateY(-2px);
    text-shadow: 0 0 10px rgba(255,255,255,0.8);
}

body {
    padding-top: 60px; /* Để không bị navbar che */
}
        
        
        .wishlist-container {
            max-width: 1000px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(44, 90, 160, 0.3);
            margin: 50px auto;

        }
        
        .wishlist-header {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            color: white;
            padding: 25px 30px;
            border-radius: 20px 20px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .wishlist-header h2 {
            margin: 0;
            font-size: 28px;
            font-weight: bold;
        }
        
        /* Stats Box */
        .stats-box {
            background: linear-gradient(145deg, #e3f2fd 0%, #d0e8f2 100%);
            padding: 20px;
            border-radius: 15px;
            margin: 20px;
            border: 2px solid #b8d4e8;
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
            justify-content: space-around;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-item .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #2c5aa0;
        }
        
        .stat-item .stat-label {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }
        
        .wishlist-img {
            width: 80px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        
        .wishlist-img:hover {
            transform: scale(1.1);
        }
        
        .wishlist-table th, .wishlist-table td {
            vertical-align: middle;
        }
        
        .wishlist-table thead {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            color: white;
        }
        
        .wishlist-table thead th {
            font-weight: 600;
            padding: 15px;
        }
        
        .clickable-row {
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .no-click {
            cursor: default !important;
        }
        
        .clickable-row:hover {
            background: linear-gradient(145deg, #e3f2fd 0%, #f0f8ff 100%) !important;
            transform: scale(1.01);
            box-shadow: 0 5px 15px rgba(44, 90, 160, 0.2);
        }
        
        .btn-buy {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            border: none;
            padding: 12px 30px;
            font-size: 18px;
            font-weight: bold;
            border-radius: 10px;
            transition: all 0.3s;
        }
        
        .btn-buy:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(44, 90, 160, 0.5);
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            border: none;
            transition: all 0.3s;
        }
        
        .btn-delete:hover {
            transform: scale(1.1);
            box-shadow: 0 3px 10px rgba(220, 53, 69, 0.4);
        }
        
        .empty-state {
            text-align: center;
            padding: 80px 20px;
        }
        
        .empty-state i {
            font-size: 100px;
            color: #b8d4e8;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            color: #2c5aa0;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            color: #666;
        }
        
        .table-container {
            padding: 20px;
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

<div class="container">
    <div class="wishlist-container">
        <!-- Header -->
        <div class="wishlist-header">
            <h2>❄️ <i class="fas fa-heart"></i> Sản phẩm yêu thích ❄️</h2>
        </div>

       <!-- Stats Box -->
<c:if test="${not empty wishList}">
    <div class="stats-box">
        <div class="stat-item">
            <div class="stat-number">${wishList.size()}</div>
            <div class="stat-label">Sản phẩm</div>
        </div>
        <div class="stat-item">
            <div class="stat-number">
                <c:set var="minPrice" value="${wishList[0].product.price}" />
                <c:set var="maxPrice" value="${wishList[0].product.price}" />
                <c:forEach var="item" items="${wishList}">
                    <c:if test="${item.product.price < minPrice}">
                        <c:set var="minPrice" value="${item.product.price}" />
                    </c:if>
                    <c:if test="${item.product.price > maxPrice}">
                        <c:set var="maxPrice" value="${item.product.price}" />
                    </c:if>
                </c:forEach>
                <fmt:formatNumber value="${minPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/>đ 
                - 
                <fmt:formatNumber value="${maxPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/>đ
            </div>
            <div class="stat-label">Khoảng giá</div>
        </div>
    </div>
</c:if>


        <c:if test="${not empty wishlistMsg}">
            <script>
                Swal.fire({
                    icon: 'success',
                    title: 'Thông báo',
                    text: '${wishlistMsg}',
                    timer: 1800,
                    showConfirmButton: false
                });
            </script>
        </c:if>

        <div class="table-container">
            <form id="wishlist-buy-form" action="dat-hang" method="get">
                <c:choose>
                    <c:when test="${not empty wishList}">
                        <table class="table table-hover wishlist-table align-middle">
                            <thead>
                                <tr>
                                    <th style="width:40px"></th>
                                    <th style="width:100px;">Ảnh</th>
                                    <th>Tên sách</th>
                                    <th style="width:140px;">Giá</th>
                                    <th style="width:80px;">Xoá</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${wishList}" varStatus="vs">
                                    <tr class="clickable-row" onclick="toggleWishlistCheckbox(${vs.index})">
                                        <td>
                                            <input type="checkbox" name="productIds" value="${item.product.id}" id="wishlistChk${vs.index}" style="width: 18px; height: 18px; cursor: pointer;">
                                        </td>
                                        <td>
                                            <img class="wishlist-img"
                                                 src="${pageContext.request.contextPath}${item.product.imagePath}"
                                                 alt=""
                                                 onerror="this.src='https://via.placeholder.com/80x100?text=No+Image'">
                                        </td>
                                        <td><strong>${item.product.bookTitle}</strong></td>
                                        <td>
                                            <span class="text-success fw-bold fs-5">
                                                <fmt:formatNumber value="${item.product.price}" type="number" maxFractionDigits="0" groupingUsed="true"/>đ
                                            </span>
                                        </td>
                                        <td class="no-click" onclick="event.stopPropagation();">
                                            <button type="button" class="btn btn-danger btn-sm btn-delete"
                                                    onclick="deleteWishlistProduct(${item.product.id}); event.stopPropagation();">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div class="d-flex justify-content-end mt-4">
                            <button type="button" class="btn btn-primary btn-buy"
                                    onclick="submitWishlistBuyForm()">
                                <i class="fas fa-shopping-cart"></i> Mua các sản phẩm đã chọn
                            </button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-heart-broken"></i>
                            <h3>Danh sách yêu thích trống</h3>
                            <p>Bạn chưa thêm sản phẩm nào vào danh sách yêu thích.</p>
                            <a href="home" class="btn btn-primary btn-buy mt-3">
                                <i class="fas fa-home"></i> Về trang chủ
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </form>
            
            <!-- Form ẩn chỉ dành cho xoá -->
            <form id="wishlistDeleteForm" action="wishlist" method="post" style="display: none;">
                <input type="hidden" name="productId" id="deleteProductId">
            </form>
        </div>
    </div>
</div>

<script>
    function toggleWishlistCheckbox(idx) {
        var checkbox = document.getElementById('wishlistChk' + idx);
        checkbox.checked = !checkbox.checked;
    }
    
    function submitWishlistBuyForm() {
        var form = document.getElementById('wishlist-buy-form');
        var checked = form.querySelectorAll('input[name="productIds"]:checked');
        if (checked.length === 0) {
            Swal.fire({
                icon: 'warning',
                title: 'Bạn chưa chọn sản phẩm nào!',
                text: 'Vui lòng tick chọn ít nhất 1 sản phẩm muốn mua.',
                timer: 1700,
                showConfirmButton: false
            });
            return false;
        }
        form.submit();
    }

    function deleteWishlistProduct(productId) {
        Swal.fire({
            icon: 'question',
            title: 'Xác nhận xóa',
            text: 'Bạn có chắc muốn xóa sản phẩm này khỏi danh sách yêu thích?',
            showCancelButton: true,
            confirmButtonText: 'Xóa',
            cancelButtonText: 'Hủy',
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d'
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('deleteProductId').value = productId;
                document.getElementById('wishlistDeleteForm').submit();
            }
        });
    }
    
    // Hiệu ứng tuyết rơi
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
</body>
</html>
