<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
        
        .checkout-container {
            max-width: 1000px;
            margin: 50px auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(44, 90, 160, 0.3);
            padding: 0;
            overflow: hidden;
        }
        
        .checkout-header {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            color: white;
            padding: 25px 36px;
        }
        
        .checkout-header h2 {
            margin: 0;
            font-size: 28px;
            font-weight: bold;
        }
        
        .checkout-body {
            padding: 32px 36px;
        }
        
        .form-label {
            font-weight: 600;
            color: #1e3a5f;
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
        
        .input-info-row {
            display: flex;
            gap: 24px;
        }
        
        .input-info-row .form-group {
            flex: 1;
        }
        
        .fs-5 {
            font-size: 1.15rem;
        }
        
        .table-checkout {
            border-radius: 10px;
            overflow: hidden;
        }
        
        .table-checkout th, .table-checkout td {
            vertical-align: middle;
        }
        
        .table-checkout thead {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            color: white;
        }
        
        .table-checkout thead th {
            font-weight: 600;
            padding: 15px;
        }
        
        .table-checkout tbody tr {
            transition: all 0.3s;
        }
        
        .table-checkout tbody tr:hover {
            background: linear-gradient(145deg, #e3f2fd 0%, #f0f8ff 100%);
            transform: scale(1.01);
        }
        
        .table-checkout tfoot {
            background: linear-gradient(145deg, #e3f2fd 0%, #d0e8f2 100%);
        }
        
        .qty-input {
            max-width: 80px;
            text-align: center;
            font-weight: bold;
            border: 2px solid #2c5aa0;
        }
        
        .btn-confirm {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            border: none;
            padding: 12px 40px;
            font-size: 18px;
            font-weight: bold;
            border-radius: 10px;
            transition: all 0.3s;
            color: white;
        }
        
        .btn-confirm:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(44, 90, 160, 0.5);
            color: white;
        }
        
        .btn-cancel {
    background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
    border: none;
    padding: 12px 40px;
    font-size: 18px;
    font-weight: bold;
    border-radius: 10px;
    transition: all 0.3s;
    color: white;
}

.btn-cancel:hover {
    transform: translateY(-3px);
    box-shadow: 0 5px 15px rgba(220, 53, 69, 0.5);
    color: white;
}
        
        
        .payment-info {
            background: linear-gradient(145deg, #e3f2fd 0%, #d0e8f2 100%);
            padding: 15px 20px;
            border-radius: 10px;
            border: 2px solid #b8d4e8;
        }
        
        .section-title {
            color: #1e3a5f;
            font-weight: bold;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-title i {
            color: #2c5aa0;
        }
    </style>
</head>
<body>
<div class="checkout-container">
    <!-- Header -->
    <div class="checkout-header">
        <h2>❄️ <i class="fas fa-shopping-cart"></i> Đặt hàng ❄️</h2>
    </div>
    
    <div class="checkout-body">
        <form id="checkout-form" action="dat-hang" method="post" autocomplete="off">
            <c:forEach var="item" items="${checkoutList}">
                <input type="hidden" name="productIds" value="${item.id}">
            </c:forEach>
            
            <!-- Thông tin người mua -->
            <h5 class="section-title">
                <i class="fas fa-user"></i> Thông tin người mua
            </h5>
            
            <div class="mb-3 input-info-row">
                <div class="form-group">
                    <label class="form-label">Họ tên <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="fullname" id="fullname" placeholder="Nhập họ và tên">
                </div>
                <div class="form-group">
                    <label class="form-label">Email <span class="text-danger">*</span></label>
                    <input type="email" class="form-control" name="email" id="email" placeholder="example@email.com">
                </div>
            </div>
            
            <div class="mb-4 input-info-row">
                <div class="form-group">
                    <label class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="address" id="address" placeholder="Số nhà, đường, phường, quận...">
                </div>
                <div class="form-group">
                    <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="phone" id="phone" placeholder="0901234567">
                </div>
            </div>

            <!-- Phương thức thanh toán -->
            <h5 class="section-title">
                <i class="fas fa-credit-card"></i> Phương thức thanh toán
            </h5>
            <div class="mb-4 payment-info">
                <label>
                    <input type="radio" checked disabled> 
                    <strong>Thanh toán trả trước</strong> (Chuyển khoản ngân hàng)
                </label>
            </div>

            <!-- Sản phẩm đặt mua -->
            <h5 class="section-title">
                <i class="fas fa-box"></i> Sản phẩm đặt mua
            </h5>
            <table class="table table-bordered table-checkout align-middle">
                <thead>
                    <tr>
                        <th>Ảnh</th>
                        <th>Tên sách</th>
                        <th>Đơn giá</th>
                        <th style="width:100px;">Số lượng</th>
                        <th>Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${checkoutList}" varStatus="vs">
                        <tr>
                            <td>
                                <img class="product-img" src="${pageContext.request.contextPath}${item.imagePath}" alt="${item.bookTitle}"
                                     onerror="this.src='https://via.placeholder.com/70x90?text=No+Image'">
                            </td>
                            <td><strong>${item.bookTitle}</strong></td>
                            <td>
                                <span class="text-success fw-bold fs-5">
                                    <fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0" groupingUsed="true"/>đ
                                </span>
                            </td>
                            <td>
                                <input type="number" class="form-control qty-input"
                                       min="1" max="10" name="quantities" value="1" data-price="${item.price}"
                                       onchange="updateLineTotal()" oninput="updateLineTotal()">
                            </td>
                            <td>
                                <span class="line-total fs-6 fw-bold text-success">
                                    <fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0" groupingUsed="true"/>đ
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <th colspan="4" class="text-end" style="font-size: 18px;">Tổng cộng:</th>
                        <th id="checkout-total" class="text-danger" style="font-size: 20px;">
                            <fmt:formatNumber value="${checkoutTotal}" type="number" maxFractionDigits="0" groupingUsed="true"/>đ
                        </th>
                    </tr>
                </tfoot>
            </table>

            <div class="d-flex justify-content-between mt-4">
    <button type="button" class="btn btn-danger btn-cancel" onclick="cancelCheckout()">
        <i class="fas fa-times"></i> Hủy thanh toán
    </button>
    <button type="button" class="btn btn-confirm" onclick="validateAndSubmitCheckout()">
        <i class="fas fa-check"></i> Xác nhận đơn hàng
    </button>
</div>

        </form>
    </div>
</div>

<script>
    function validateAndSubmitCheckout() {
        let valid = true;
        let msg = "";
        const name = document.getElementById('fullname').value.trim();
        const email = document.getElementById('email').value.trim();
        const address = document.getElementById('address').value.trim();
        const phone = document.getElementById('phone').value.trim();
        
        if (name === "")           { valid = false; msg = "Vui lòng nhập họ tên."; }
        else if (!/^\S+@\S+\.\S+$/.test(email)) { valid = false; msg = "Địa chỉ email không hợp lệ."; }
        else if (address === "")   { valid = false; msg = "Vui lòng nhập địa chỉ."; }
        else if (!/^(0[0-9]{9,10})$/.test(phone)) { valid = false; msg = "Số điện thoại không hợp lệ."; }

        const qtyInputs = document.querySelectorAll('.qty-input');
        for (let i = 0; i < qtyInputs.length; i++) {
            const qty = Number(qtyInputs[i].value);
            if (qty < 1 || qty > 10) {
                valid = false;
                msg = "Mỗi sản phẩm chỉ được mua tối đa 10 quyển.";
                break;
            }
        }
        
        if (!valid) {
            Swal.fire({ icon: 'warning', title: 'Lỗi', text: msg, timer: 1800, showConfirmButton: false });
            return false;
        }
        
        document.getElementById('checkout-form').submit();
    }

    function updateLineTotal() {
        const rows = document.querySelectorAll('.table-checkout tbody tr');
        let total = 0;
        rows.forEach(function(row) {
            const qtyInput = row.querySelector('.qty-input');
            let qty = Number(qtyInput.value);
            if (qty < 1) qty = 1;
            if (qty > 10) qty = 10;
            qtyInput.value = qty;
            const price = Number(qtyInput.getAttribute('data-price'));
            const lineTotal = qty * price;
            row.querySelector('.line-total').innerText = lineTotal.toLocaleString('vi-VN') + "đ";
            total += lineTotal;
        });
        document.getElementById('checkout-total').innerText = total.toLocaleString('vi-VN') + "đ";
    }
    
    function cancelCheckout() {
        Swal.fire({
            icon: 'question',
            title: 'Xác nhận hủy thanh toán',
            text: 'Bạn có chắc chắn muốn hủy đơn hàng này?',
            showCancelButton: true,
            confirmButtonText: 'Hủy đơn hàng',
            cancelButtonText: 'Tiếp tục mua',
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    icon: 'success',
                    title: 'Đã hủy thành công!',
                    text: 'Đơn hàng đã được hủy.',
                    timer: 1500,
                    showConfirmButton: false
                }).then(() => {
                    window.location.href = 'home';
                });
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
