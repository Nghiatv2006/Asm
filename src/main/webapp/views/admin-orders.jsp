<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn hàng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd 0%, #f0f8ff 100%);
            position: relative;
            overflow-x: hidden;
        }
        
        /* Hiệu ứng tuyết rơi */
        .snowflake {
            position: fixed;
            top: -10px;
            z-index: 9999;
            color: #b0d4e8;
            font-size: 1em;
            font-family: Arial, sans-serif;
            text-shadow: 0 0 3px #fff;
            pointer-events: none;
            animation: fall linear infinite;
        }
        
        @keyframes fall {
            to {
                transform: translateY(100vh);
            }
        }
        
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #2c5aa0 0%, #1e3a5f 100%);
            padding: 20px;
            position: fixed;
            width: 250px;
            top: 0;
            left: 0;
            z-index: 1000;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        
        .sidebar h4 {
            color: white;
            margin-bottom: 30px;
            font-weight: bold;
        }
        
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 12px 15px;
            margin: 8px 0;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .sidebar a:hover, .sidebar a.active {
            background: rgba(255,255,255,0.2);
            transform: translateX(5px);
        }
        
        .sidebar a i {
            margin-right: 10px;
            width: 20px;
        }
        
        .content-area {
            margin-left: 250px;
            padding: 30px;
        }
        
        .card {
            border: none;
            box-shadow: 0 5px 20px rgba(44, 90, 160, 0.15);
            border-radius: 15px;
        }
        
        .table thead {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            color: white;
        }
        
        .table tbody tr:hover {
            background: #e3f2fd;
        }
    </style>
</head>
<body>
<div class="container-fluid p-0">
    <!-- SIDEBAR -->
    <div class="sidebar">
        <h4><i class="fas fa-book-open"></i> Bookstore</h4>
        <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-home"></i> Trang chủ</a>
        <a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> Khách hàng</a>
        <a href="${pageContext.request.contextPath}/admin/categories"><i class="fas fa-list"></i> Danh mục</a>
        <a href="${pageContext.request.contextPath}/admin/products"><i class="fas fa-book"></i> Sản phẩm</a>
        <a href="${pageContext.request.contextPath}/admin/orders" class="active"><i class="fas fa-shopping-cart"></i> Đơn hàng</a>
        <hr style="border-color: rgba(255,255,255,0.3); margin: 20px 0;">
        <a href="${pageContext.request.contextPath}/home"><i class="fas fa-store"></i> Xem Website</a>
        <a href="#" onclick="confirmLogout(event)"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
    </div>

    <!-- CONTENT -->
    <div class="content-area">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-shopping-cart text-primary"></i> Danh sách Đơn hàng</h2>
        </div>

        <div class="card">
            <div class="card-body">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Khách hàng</th>
                        <th>Email</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Chi tiết</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td><strong>#${o.id}</strong></td>
                            <td>${o.user.fullName != null ? o.user.fullName : o.user.username}</td>
                            <td>${o.user.email}</td>
                            <td>${o.orderDateFormatted}</td>
                            <td class="text-success fw-bold">
                                <fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0" groupingUsed="true"/>đ
                            </td>
                            <td>
                                <span class="badge 
                                    ${o.status == 'COMPLETED' ? 'bg-success' : (o.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark')}">
                                    ${o.status}
                                </span>
                            </td>
                            <td>
                                <a class="btn btn-sm btn-info"
                                   href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.id}">
                                    <i class="fas fa-eye"></i> Xem
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <c:if test="${empty orders}">
                    <p class="text-muted text-center py-4">Chưa có đơn hàng nào.</p>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Popup xác nhận đăng xuất
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
                window.location.href = '${pageContext.request.contextPath}/logout';
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
        snowflake.style.opacity = Math.random() * 0.5 + 0.2;
        snowflake.style.fontSize = Math.random() * 20 + 15 + 'px';
        
        document.body.appendChild(snowflake);
        
        setTimeout(() => {
            snowflake.remove();
        }, 9000);
    }
    
    setInterval(createSnowflake, 250);
</script>
</body>
</html>
