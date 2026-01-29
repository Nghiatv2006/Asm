<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng #${order.id}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #4a90e2 0%, #7ec8e3 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            position: relative;
            overflow-x: hidden;
            min-height: 100vh;
            padding-top: 70px;
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
        
        .navbar {
            background: linear-gradient(135deg, #2c5aa0 0%, #1e3a5f 100%);
            padding: 5px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.3);
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
        
        .order-container {
            max-width: 1000px;
            margin: 40px auto;
        }
        
        .card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(44, 90, 160, 0.3);
            margin-bottom: 30px;
            background: white;
            overflow: hidden;
        }
        
        .card-header {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            color: white;
            padding: 20px 25px;
            font-size: 22px;
            font-weight: bold;
        }
        
        .card-body {
            padding: 30px;
        }
        
        .info-box {
            background: linear-gradient(145deg, #e3f2fd 0%, #d0e8f2 100%);
            padding: 20px;
            border-radius: 15px;
            border: 2px solid #b8d4e8;
        }
        
        .info-box p {
            margin-bottom: 10px;
        }
        
        .product-img {
            width: 70px;
            height: 90px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        
        .product-img:hover {
            transform: scale(1.1);
        }
        
        .table thead {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            color: white;
        }
        
        .table thead th {
            padding: 15px;
            font-weight: 600;
        }
        
        .table tbody tr {
            transition: all 0.3s;
        }
        
        .table tbody tr:hover {
            background: linear-gradient(145deg, #e3f2fd 0%, #f0f8ff 100%);
            transform: scale(1.01);
        }
        
        .table tfoot {
            background: linear-gradient(145deg, #e3f2fd 0%, #d0e8f2 100%);
        }
        
        .btn-back {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            border: none;
            padding: 10px 25px;
            border-radius: 10px;
            transition: all 0.3s;
            color: white;
        }
        
        .btn-back:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.5);
            color: white;
        }
        
        .order-header {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(44, 90, 160, 0.2);
            margin-bottom: 30px;
        }
        
        .order-header h2 {
            color: #1e3a5f;
            margin-bottom: 0;
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
                    <li class="nav-item">
                        <a class="nav-link" href="wishlist"><i class="fas fa-heart"></i> Yêu Thích</a>
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
                        <a class="nav-link" href="logout"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Order Detail Container -->
    <div class="order-container">
        <div class="order-header d-flex justify-content-between align-items-center">
            <h2>
                <i class="fas fa-receipt text-primary"></i>
                Đơn hàng #${order.id}
            </h2>
            <a href="profile" class="btn btn-back">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <!-- Thông tin người nhận -->
        <div class="card">
            <div class="card-header">
                <i class="fas fa-shipping-fast"></i> Thông tin người nhận hàng
            </div>
            <div class="card-body">
                <div class="info-box">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong><i class="fas fa-user"></i> Họ tên:</strong> ${order.recipientName}</p>
                            <p><strong><i class="fas fa-envelope"></i> Email:</strong> ${order.recipientEmail}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong><i class="fas fa-phone"></i> Số điện thoại:</strong> ${order.recipientPhone}</p>
                            <p><strong><i class="fas fa-map-marker-alt"></i> Địa chỉ:</strong> ${order.shippingAddress}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Thông tin đơn hàng -->
        <div class="card">
            <div class="card-header">
                <i class="fas fa-info-circle"></i> Thông tin đơn hàng
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <p><strong><i class="fas fa-calendar"></i> Ngày đặt:</strong><br>${order.orderDateFormatted}</p>
                    </div>
                    <div class="col-md-4">
                        <p>
                            <strong><i class="fas fa-tasks"></i> Trạng thái:</strong><br>
                            <span class="badge 
                                ${order.status == 'COMPLETED' ? 'bg-success' : 
                                  (order.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark')}"
                                  style="font-size: 16px; padding: 8px 15px;">
                                ${order.status}
                            </span>
                        </p>
                    </div>
                    <div class="col-md-4">
                        <p>
                            <strong><i class="fas fa-money-bill-wave"></i> Tổng tiền:</strong><br>
                            <span class="text-success fs-4 fw-bold">
                                <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0" groupingUsed="true"/> đ
                            </span>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Chi tiết sản phẩm -->
        <div class="card">
            <div class="card-header">
                <i class="fas fa-box"></i> Danh sách sản phẩm
            </div>
            <div class="card-body">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>Ảnh</th>
                            <th>Tên sách</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="d" items="${orderDetails}">
                            <tr>
                                <td>
                                    <c:if test="${not empty d.productImage}">
                                        <img src="${pageContext.request.contextPath}${d.productImage}"
                                             class="product-img" alt="${d.bookTitle}"/>
                                    </c:if>
                                </td>
                                <td><strong>${d.bookTitle}</strong></td>
                                <td class="text-success fw-bold">
                                    <fmt:formatNumber value="${d.productPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/> đ
                                </td>
                                <td><span class="badge bg-primary">${d.quantity}</span></td>
                                <td class="fw-bold text-success">
                                    <fmt:formatNumber value="${d.productPrice * d.quantity}" type="number" maxFractionDigits="0" groupingUsed="true"/> đ
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th colspan="4" class="text-end" style="font-size: 18px; padding: 20px;">
                                <i class="fas fa-calculator"></i> Tổng cộng:
                            </th>
                            <th class="text-danger" style="font-size: 22px; padding: 20px;">
                                <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0" groupingUsed="true"/> đ
                            </th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
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
    </script>
</body>
</html>
