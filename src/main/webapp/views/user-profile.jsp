<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông tin cá nhân</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
        
        .profile-container {
            max-width: 900px;
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
        
        .form-label {
            font-weight: 600;
            color: #1e3a5f;
            margin-bottom: 8px;
        }
        
        .form-control {
            border: 2px solid #d0e8f2;
            border-radius: 10px;
            padding: 10px 15px;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: #2c5aa0;
            box-shadow: 0 0 0 0.2rem rgba(44, 90, 160, 0.25);
        }
        
        .badge-role {
            font-size: 16px;
            padding: 10px 20px;
            border-radius: 10px;
        }
        
        .order-table {
            font-size: 15px;
        }
        
        .order-table thead {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            color: white;
        }
        
        .order-table thead th {
            padding: 15px;
            font-weight: 600;
        }
        
        .order-table tbody tr {
            transition: all 0.3s;
        }
        
        .order-table tbody tr:hover {
            background: linear-gradient(145deg, #e3f2fd 0%, #f0f8ff 100%);
            transform: scale(1.01);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            border: none;
            padding: 10px 25px;
            border-radius: 10px;
            transition: all 0.3s;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(44, 90, 160, 0.5);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            border: none;
            padding: 10px 25px;
            border-radius: 10px;
            transition: all 0.3s;
        }
        
        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.5);
        }
        
        .modal-content {
            border-radius: 20px;
            border: none;
            box-shadow: 0 10px 40px rgba(44, 90, 160, 0.3);
        }
        
        .modal-header {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            color: white;
            border-radius: 20px 20px 0 0;
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
                        <a class="nav-link" href="#" onclick="confirmLogout(event)">
                            <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Profile Container -->
    <div class="profile-container">
        <!-- Thông báo -->
        <c:if test="${not empty sessionScope.profileMsg}">
            <script>
                Swal.fire({
                    icon: 'info',
                    title: '${sessionScope.profileMsg}',
                    timer: 2000,
                    showConfirmButton: false
                });
            </script>
            <c:remove var="profileMsg" scope="session"/>
        </c:if>

        <!-- Card 1: Thông tin cá nhân -->
        <div class="card">
            <div class="card-header">
                <i class="fas fa-user-circle"></i> Thông tin cá nhân
            </div>
            <div class="card-body">
                <form action="profile" method="post" id="profileForm" onsubmit="return validateProfileForm()">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Username</label>
                            <input type="text" class="form-control" value="${user.username}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Vai trò</label><br>
                            <span class="badge ${user.role == 'ADMIN' ? 'bg-danger' : 'bg-primary'} badge-role">
                                ${user.role}
                            </span>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Họ tên</label>
                            <input type="text" class="form-control" name="fullname" id="fullname" value="${user.fullName}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" name="email" id="email" value="${user.email}">
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" name="phone" id="phone" value="${user.phone}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày tạo tài khoản</label>
                            <input type="text" class="form-control" value="${user.createdDateFormatted}" readonly>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Địa chỉ</label>
                        <input type="text" class="form-control" name="address" id="address" value="${user.address}">
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="fas fa-save"></i> Lưu thông tin
                        </button>
                        <button type="button" class="btn btn-secondary px-4" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                            <i class="fas fa-key"></i> Đổi mật khẩu
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Card 2: Lịch sử đơn hàng -->
        <div class="card">
            <div class="card-header">
                <i class="fas fa-history"></i> Lịch sử đơn hàng
            </div>
            <div class="card-body">
                <c:if test="${empty orders}">
                    <p class="text-muted text-center py-4">Bạn chưa có đơn hàng nào.</p>
                </c:if>
                
                <c:if test="${not empty orders}">
                    <table class="table table-hover order-table align-middle">
                        <thead>
                            <tr>
                                <th>Mã đơn hàng</th>
                                <th>Ngày đặt</th>
                                <th>Trạng thái</th>
                                <th>Tổng tiền</th>
                                <th>Chi tiết</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td><strong>#${order.id}</strong></td>
                                    <td>${order.orderDateFormatted}</td>
                                    <td>
                                        <span class="badge 
                                            ${order.status == 'COMPLETED' ? 'bg-success' : 
                                              (order.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark')}">
                                            ${order.status}
                                        </span>
                                    </td>
                                    <td class="text-success fw-bold">
                                        <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0" groupingUsed="true"/> đ
                                    </td>
                                    <td>
                                        <a href="user-order-detail?id=${order.id}" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-eye"></i> Xem
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Modal Đổi Mật Khẩu -->
    <div class="modal fade" id="changePasswordModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-key"></i> Đổi mật khẩu</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="change-password" method="post" id="changePasswordForm" onsubmit="return validateChangePassword()">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Mật khẩu cũ <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" name="oldPassword" id="oldPassword">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mật khẩu mới <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" name="newPassword" id="newPassword">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Nhập lại mật khẩu mới <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" name="confirmPassword" id="confirmPassword">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Xác nhận</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validate form thông tin cá nhân
        function validateProfileForm() {
            const fullname = document.getElementById('fullname').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const address = document.getElementById('address').value.trim();
            
            if (fullname === "") {
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Vui lòng nhập họ tên!', timer: 1800, showConfirmButton: false});
                return false;
            }
            
            if (!/^\S+@\S+\.\S+$/.test(email)) {
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Email không hợp lệ!', timer: 1800, showConfirmButton: false});
                return false;
            }
            
            if (phone !== "" && !/^(0[0-9]{9,10})$/.test(phone)) {
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Số điện thoại không hợp lệ!', timer: 1800, showConfirmButton: false});
                return false;
            }
            
            if (address === "") {
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Vui lòng nhập địa chỉ!', timer: 1800, showConfirmButton: false});
                return false;
            }
            
            return true;
        }
        
        // Validate form đổi mật khẩu
        function validateChangePassword() {
            const oldPassword = document.getElementById('oldPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (oldPassword === "") {
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Vui lòng nhập mật khẩu cũ!', timer: 1800, showConfirmButton: false});
                return false;
            }
            
            if (newPassword.length < 6) {
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Mật khẩu mới phải có ít nhất 6 ký tự!', timer: 1800, showConfirmButton: false});
                return false;
            }
            
            if (newPassword !== confirmPassword) {
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Mật khẩu mới không khớp!', timer: 1800, showConfirmButton: false});
                return false;
            }
            
            return true;
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
                    window.location.href = 'logout';
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
    </script>
</body>
</html>
