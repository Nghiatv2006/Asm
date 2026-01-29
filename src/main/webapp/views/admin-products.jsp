<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sản phẩm - Admin</title>
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
        @keyframes fall { to { transform: translateY(100vh);} }
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
        .sidebar h4 { color: white; margin-bottom: 30px; font-weight: bold; }
        .sidebar a { color: white; text-decoration: none; display: block; padding: 12px 15px; margin: 8px 0; border-radius: 8px; transition: all 0.3s; }
        .sidebar a:hover, .sidebar a.active { background: rgba(255,255,255,0.2); transform: translateX(5px); }
        .sidebar a i { margin-right: 10px; width: 20px; }
        .content-area { margin-left: 250px; padding: 30px; }
        .card { border: none; box-shadow: 0 5px 20px rgba(44,90,160,0.15); border-radius: 15px; }
        .btn-custom { border-radius: 10px; padding: 10px 25px; }
        .product-img { width: 60px; height: 80px; object-fit: cover; border-radius: 5px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .table thead { background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%); color: white; }
        .table tbody tr:hover { background: #e3f2fd; }
    </style>
</head>
<body>
<div class="container-fluid p-0">
    <div class="sidebar">
        <h4><i class="fas fa-book-open"></i> Bookstore</h4>
        <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-home"></i> Trang chủ</a>
        <a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> Khách hàng</a>
        <a href="${pageContext.request.contextPath}/admin/categories"><i class="fas fa-list"></i> Danh mục</a>
        <a href="${pageContext.request.contextPath}/admin/products" class="active"><i class="fas fa-book"></i> Sản phẩm</a>
        <a href="${pageContext.request.contextPath}/admin/orders"><i class="fas fa-shopping-cart"></i> Đơn hàng</a>
        <hr style="border-color: rgba(255,255,255,0.3); margin: 20px 0;">
        <a href="${pageContext.request.contextPath}/home"><i class="fas fa-store"></i> Xem Website</a>
        <a href="#" onclick="confirmLogout(event)"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
    </div>

    <div class="content-area">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-book text-primary"></i> Quản lý Sản phẩm</h2>
            <button class="btn btn-primary btn-custom" data-bs-toggle="modal" data-bs-target="#productModal" onclick="resetForm()">
                <i class="fas fa-plus"></i> Thêm sản phẩm
            </button>
        </div>

        <div class="card">
            <div class="card-body">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Ảnh</th>
                            <th>Tên sách</th>
                            <th>Tác giả</th>
                            <th>Giá</th>
                            <th>Danh mục</th>
                            <th>Tồn kho</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td>${p.id}</td>
                                <td><img src="${pageContext.request.contextPath}${p.imagePath}" class="product-img" alt="${p.bookTitle}"></td>
                                <td><strong>${p.bookTitle}</strong></td>
                                <td>${p.author}</td>
                                <td class="text-success fw-bold"><fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0" groupingUsed="true"/>đ</td>
                                <td><span class="badge bg-info">${p.category.categoryName}</span></td>
                                <td>${p.stockQuantity}</td>
                                <td>
                                    <button class="btn btn-sm btn-warning" onclick="editProduct(${p.id})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-danger" onclick="deleteProduct(${p.id}, '${p.bookTitle}')">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty products}">
                    <p class="text-muted text-center py-4">Chưa có sản phẩm nào.</p>
                </c:if>

            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="productModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Thêm sản phẩm mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="id" id="productId">
                    <div class="mb-3">
                        <label class="form-label">Tên sách <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="bookTitle" id="bookTitle">
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Tác giả <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="author" id="author">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Nhà xuất bản <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="publisher" id="publisher">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Giá <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="price" id="price" step="1">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Tồn kho <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="stockQuantity" id="stockQuantity">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Danh mục <span class="text-danger">*</span></label>
                            <select class="form-select" name="categoryId" id="categoryId">
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.id}">${cat.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả</label>
                        <textarea class="form-control" name="description" id="description" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Ảnh sản phẩm <span class="text-danger" id="imgRequired">*</span></label>
                        <input type="file" class="form-control" name="productImage" id="productImage" accept="image/*">
                        <small class="text-muted" id="imgHint" style="display:none;">Để trống nếu không đổi ảnh</small>
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

<c:if test="${not empty product}">
document.getElementById('modalTitle').innerText = 'Chỉnh sửa sản phẩm';
document.getElementById('productId').value = '${product.id}';
document.getElementById('bookTitle').value = '${product.bookTitle}';
document.getElementById('author').value = '${product.author}';
document.getElementById('publisher').value = '${product.publisher}';
document.getElementById('price').value = '${product.price}';
document.getElementById('stockQuantity').value = '${product.stockQuantity}';
document.getElementById('categoryId').value = '${product.category.id}';
document.getElementById('description').value = '${product.description}';
document.getElementById('imgRequired').style.display = 'none';
document.getElementById('imgHint').style.display = '';
new bootstrap.Modal(document.getElementById('productModal')).show();
</c:if>

<c:if test="${not empty formData && messageType == 'error'}">
window.addEventListener('DOMContentLoaded', function() {
    var id = '${formData.id[0]}';
    if (id && id !== 'null' && id !== '') {
        document.getElementById('modalTitle').innerText = 'Chỉnh sửa sản phẩm';
        document.getElementById('productId').value = id;
        document.getElementById('imgRequired').style.display = 'none';
        document.getElementById('imgHint').style.display = '';
    }
    document.getElementById('bookTitle').value = '${formData.bookTitle[0]}';
    document.getElementById('author').value = '${formData.author[0]}';
    document.getElementById('publisher').value = '${formData.publisher[0]}';
    document.getElementById('price').value = '${formData.price[0]}';
    document.getElementById('stockQuantity').value = '${formData.stockQuantity[0]}';
    document.getElementById('categoryId').value = '${formData.categoryId[0]}';
    document.getElementById('description').value = '${formData.description[0]}';
    new bootstrap.Modal(document.getElementById('productModal')).show();
});
</c:if>

function resetForm() {
    document.getElementById('modalTitle').innerText = 'Thêm sản phẩm mới';
    document.getElementById('productId').value = '';
    document.getElementById('bookTitle').value = '';
    document.getElementById('author').value = '';
    document.getElementById('publisher').value = '';
    document.getElementById('price').value = '';
    document.getElementById('stockQuantity').value = '0';
    document.getElementById('categoryId').value = '';
    document.getElementById('description').value = '';
    document.getElementById('productImage').value = '';
    document.getElementById('imgRequired').style.display = '';
    document.getElementById('imgHint').style.display = 'none';
}

function editProduct(id) {
    window.location.href = '${pageContext.request.contextPath}/admin/products?action=edit&id=' + id;
}

function deleteProduct(id, name) {
    Swal.fire({
        title: 'Xác nhận xóa?',
        text: 'Bạn có chắc muốn xóa sản phẩm "' + name + '"?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = '${pageContext.request.contextPath}/admin/products?action=delete&id=' + id;
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
