<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Danh mục - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd 0%, #f0f8ff 100%);
            position: relative;
            overflow-x: hidden;
        }
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
        .btn-custom {
            border-radius: 10px;
            padding: 10px 25px;
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
    <div class="sidebar">
        <h4><i class="fas fa-book-open"></i> Bookstore</h4>
        <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-home"></i> Trang chủ</a>
        <a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> Khách hàng</a>
        <a href="${pageContext.request.contextPath}/admin/categories" class="active"><i class="fas fa-list"></i> Danh mục</a>
        <a href="${pageContext.request.contextPath}/admin/products"><i class="fas fa-book"></i> Sản phẩm</a>
        <a href="${pageContext.request.contextPath}/admin/orders"><i class="fas fa-shopping-cart"></i> Đơn hàng</a>
        <hr style="border-color: rgba(255,255,255,0.3); margin: 20px 0;">
        <a href="${pageContext.request.contextPath}/home"><i class="fas fa-store"></i> Xem Website</a>
        <a href="#" onclick="confirmLogout(event)"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
    </div>

    <div class="content-area">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-list text-primary"></i> Quản lý Danh mục</h2>
            <button class="btn btn-primary btn-custom" data-bs-toggle="modal" data-bs-target="#categoryModal" onclick="resetForm()">
                <i class="fas fa-plus"></i> Thêm danh mục
            </button>
        </div>

        <div class="card">
            <div class="card-body">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên danh mục</th>
                        <th>Mô tả</th>
                        <th>Số sản phẩm</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="cat" items="${categories}">
                        <tr>
                            <td>${cat.id}</td>
                            <td><strong>${cat.categoryName}</strong></td>
                            <td>${cat.description}</td>
                            <td>
                                <span class="badge bg-info text-dark">
                                    ${categoryProductCount[cat.id]}
                                </span>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-warning"
                                        onclick="editCategory(${cat.id}, '${fn:escapeXml(cat.categoryName)}', '${fn:escapeXml(cat.description)}')">
                                    <i class="fas fa-edit"></i> Sửa
                                </button>
                                <button class="btn btn-sm btn-danger"
                                        onclick="deleteCategory(${cat.id}, '${fn:escapeXml(cat.categoryName)}')">
                                    <i class="fas fa-trash"></i> Xóa
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <c:if test="${empty categories}">
                    <p class="text-muted text-center py-4">Chưa có danh mục nào.</p>
                </c:if>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="categoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Thêm danh mục mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/categories" method="post">
                <div class="modal-body">
                    <input type="hidden" name="id" id="categoryId">
                    <div class="mb-3">
                        <label class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="categoryName" id="categoryName">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả</label>
                        <textarea class="form-control" name="description" id="description" rows="3"></textarea>
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
        document.getElementById('modalTitle').innerText = 'Chỉnh sửa danh mục';
        document.getElementById('categoryId').value = id;
    } else {
        document.getElementById('modalTitle').innerText = 'Thêm danh mục mới';
    }
    document.getElementById('categoryName').value = '${formData.categoryName[0]}';
    document.getElementById('description').value = '${formData.description[0]}';
    new bootstrap.Modal(document.getElementById('categoryModal')).show();
});
</c:if>

function resetForm() {
    document.getElementById('modalTitle').innerText = 'Thêm danh mục mới';
    document.getElementById('categoryId').value = '';
    document.getElementById('categoryName').value = '';
    document.getElementById('description').value = '';
}

function editCategory(id, name, desc) {
    document.getElementById('modalTitle').innerText = 'Chỉnh sửa danh mục';
    document.getElementById('categoryId').value = id;
    document.getElementById('categoryName').value = name;
    document.getElementById('description').value = desc;
    new bootstrap.Modal(document.getElementById('categoryModal')).show();
}

function deleteCategory(id, name) {
    Swal.fire({
        title: 'Xác nhận xóa?',
        text: 'Bạn có chắc muốn xóa danh mục "' + name + '"?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = '${pageContext.request.contextPath}/admin/categories?action=delete&id=' + id;
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
