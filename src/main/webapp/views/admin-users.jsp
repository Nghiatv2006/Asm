<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khách hàng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd 0%, #f0f8ff 100%);
            position: relative;
            overflow-x: hidden;
        }
        .snowflake { position: fixed; top: -10px; z-index: 9999; color: #b0d4e8; font-size: 1em; font-family: Arial, sans-serif; text-shadow: 0 0 3px #fff; pointer-events: none; animation: fall linear infinite; }
        @keyframes fall { to { transform: translateY(100vh);} }
        .sidebar { min-height: 100vh; background: linear-gradient(135deg, #2c5aa0 0%, #1e3a5f 100%); padding: 20px; position: fixed; width: 250px; top: 0; left: 0; z-index: 1000; box-shadow: 2px 0 10px rgba(0,0,0,0.1);}
        .sidebar h4 { color: white; margin-bottom: 30px; font-weight: bold;}
        .sidebar a { color: white; text-decoration: none; display: block; padding: 12px 15px; margin: 8px 0; border-radius: 8px; transition: all 0.3s;}
        .sidebar a:hover, .sidebar a.active { background: rgba(255, 255, 255, 0.2); transform: translateX(5px);}
        .sidebar a i { margin-right: 10px; width: 20px;}
        .content-area { margin-left: 250px; padding: 30px;}
        .card { border: none; box-shadow: 0 5px 20px rgba(44, 90, 160, 0.15); border-radius: 15px;}
        .btn-custom { border-radius: 10px; padding: 10px 25px;}
        .badge-role { padding: 5px 10px; border-radius: 5px;}
        .table thead { background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%); color: white;}
        .table tbody tr:hover { background: #e3f2fd;}
    </style>
</head>
<body>
<div class="container-fluid p-0">
    <div class="sidebar">
        <h4><i class="fas fa-book-open"></i> Bookstore</h4>
        <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-home"></i> Trang chủ</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="active"><i class="fas fa-users"></i> Khách hàng</a>
        <a href="${pageContext.request.contextPath}/admin/categories"><i class="fas fa-list"></i> Danh mục</a>
        <a href="${pageContext.request.contextPath}/admin/products"><i class="fas fa-book"></i> Sản phẩm</a>
        <a href="${pageContext.request.contextPath}/admin/orders"><i class="fas fa-shopping-cart"></i> Đơn hàng</a>
        <hr style="border-color: rgba(255,255,255,0.3); margin: 20px 0;">
        <a href="${pageContext.request.contextPath}/home"><i class="fas fa-store"></i> Xem Website</a>
        <a href="#" onclick="confirmLogout(event)"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
    </div>

    <div class="content-area">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-users text-primary"></i> Quản lý Khách hàng</h2>
            <button class="btn btn-primary btn-custom" data-bs-toggle="modal" data-bs-target="#userModal" onclick="resetForm()">
                <i class="fas fa-plus"></i> Thêm người dùng
            </button>
        </div>

        <div class="card">
            <div class="card-body">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Họ tên</th>
                            <th>Số điện thoại</th>
                            <th>Vai trò</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>${u.id}</td>
                                <td><strong>${u.username}</strong></td>
                                <td>${u.email}</td>
                                <td>${u.fullName}</td>
                                <td>${u.phone}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.role == 'ADMIN'}">
                                            <span class="badge bg-danger badge-role">ADMIN</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success badge-role">USER</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-warning" onclick="editUser(${u.id}, '${u.username}', '${u.email}', '${u.fullName}', '${u.phone}', '${u.address}', '${u.role}')">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-danger" onclick="deleteUser(${u.id}, '${u.username}')">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="userModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Thêm người dùng mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/users" method="post">
                <div class="modal-body">
                    <input type="hidden" name="id" id="userId">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Username <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="username" id="username">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" name="email" id="email">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Mật khẩu <span class="text-danger" id="pwdRequired">*</span></label>
                            <input type="text" class="form-control" name="password" id="password" autocomplete="new-password">
                            <small class="text-muted" id="pwdHint" style="display:none;">Để trống nếu không đổi mật khẩu</small>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Vai trò <span class="text-danger">*</span></label>
                            <select class="form-select" name="role" id="role">
                                <option value="USER">USER</option>
                                <option value="ADMIN">ADMIN</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Họ tên <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="fullName" id="fullName">
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" name="phone" id="phone">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Địa chỉ</label>
                            <input type="text" class="form-control" name="address" id="address">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
<%
String reqMessage = (String) request.getAttribute("message");
String reqType = (String) request.getAttribute("messageType");
if (reqMessage == null) {
    reqMessage = (String) session.getAttribute("message");
    reqType = (String) session.getAttribute("messageType");
    if (reqMessage != null) {
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    }
}
if (reqMessage != null) {
%>
Swal.fire({
    icon: '<%= "success".equals(reqType) ? "success" : "error" %>',
    title: '<%= "success".equals(reqType) ? "Thành công!" : "Lỗi!" %>',
    text: '<%= reqMessage %>',
    timer: 2000,
    showConfirmButton: false
});
<% } %>

<c:if test="${not empty formData && messageType == 'error'}">
window.addEventListener('DOMContentLoaded', function() {
    var id = '${formData.id[0]}';
    if (id && id !== 'null' && id !== '') {
        document.getElementById('modalTitle').innerText = 'Chỉnh sửa người dùng';
        document.getElementById('pwdRequired').style.display = 'none';
        document.getElementById('pwdHint').style.display = '';
    }
    document.getElementById('userId').value = '${formData.id[0]}';
    document.getElementById('username').value = '${formData.username[0]}';
    document.getElementById('email').value = '${formData.email[0]}';
    document.getElementById('password').value = '${formData.password[0]}';
    document.getElementById('fullName').value = '${formData.fullName[0]}';
    document.getElementById('phone').value = '${formData.phone[0]}';
    document.getElementById('address').value = '${formData.address[0]}';
    document.getElementById('role').value = '${formData.role[0]}';
    new bootstrap.Modal(document.getElementById('userModal')).show();
});
</c:if>

function resetForm() {
    document.getElementById('modalTitle').innerText = 'Thêm người dùng mới';
    document.getElementById('userId').value = '';
    document.getElementById('username').value = '';
    document.getElementById('email').value = '';
    document.getElementById('password').value = '';
    document.getElementById('fullName').value = '';
    document.getElementById('phone').value = '';
    document.getElementById('address').value = '';
    document.getElementById('role').value = 'USER';
    document.getElementById('pwdRequired').style.display = '';
    document.getElementById('pwdHint').style.display = 'none';
}

function editUser(id, username, email, fullName, phone, address, role) {
    document.getElementById('modalTitle').innerText = 'Chỉnh sửa người dùng';
    document.getElementById('userId').value = id;
    document.getElementById('username').value = username;
    document.getElementById('email').value = email;
    document.getElementById('password').value = '';
    document.getElementById('fullName').value = fullName;
    document.getElementById('phone').value = phone;
    document.getElementById('address').value = address;
    document.getElementById('role').value = role;
    document.getElementById('pwdRequired').style.display = 'none';
    document.getElementById('pwdHint').style.display = '';
    new bootstrap.Modal(document.getElementById('userModal')).show();
}

function deleteUser(id, username) {
    Swal.fire({
        title: 'Xác nhận xóa?',
        text: 'Bạn có chắc muốn xóa người dùng "' + username + '"?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = '${pageContext.request.contextPath}/admin/users?action=delete&id=' + id;
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
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    });
}

function createSnowflake() {
    const snowflake = document.createElement('div');
    snowflake.classList.add('snowflake');
    snowflake.innerHTML = '❄';
    snowflake.style.left = Math.random() * window.innerWidth + 'px';
    snowflake.style.animationDuration = Math.random() * 5 + 4 + 's';
    snowflake.style.opacity = Math.random() * 0.5 + 0.2;
    snowflake.style.fontSize = Math.random() * 20 + 15 + 'px';
    document.body.appendChild(snowflake);
    setTimeout(() => snowflake.remove(), 9000);
}
setInterval(createSnowflake, 250);
</script>
</body>
</html>
