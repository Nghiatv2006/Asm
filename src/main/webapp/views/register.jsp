<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - Bookstore</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <style>
        body {
            background: linear-gradient(135deg, #4a90e2 0%, #7ec8e3 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
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
        
        .register-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 50px rgba(44, 90, 160, 0.4);
            padding: 40px;
            max-width: 500px;
            width: 100%;
            animation: slideDown 0.5s ease-out;
            margin: 30px 0;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .register-header h2 {
            color: #2c5aa0;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .register-header p {
            color: #666;
            font-size: 14px;
        }
        
        .form-label {
            font-weight: 600;
            color: #1e3a5f;
            margin-bottom: 8px;
        }
        
        .form-control {
            border-radius: 10px;
            padding: 12px 20px;
            border: 2px solid #d0e8f2;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: #2c5aa0;
            box-shadow: 0 0 0 0.2rem rgba(44, 90, 160, 0.25);
        }
        
        .input-group-text {
            border-radius: 10px 0 0 10px;
            border: 2px solid #d0e8f2;
            border-right: none;
            background: linear-gradient(145deg, #e3f2fd 0%, #f0f8ff 100%);
            color: #2c5aa0;
        }
        
        .input-group .form-control {
            border-left: none;
            border-radius: 0 10px 10px 0;
        }
        
        .btn-send-otp {
            border-radius: 0 10px 10px 0;
            padding: 12px 20px;
            font-weight: bold;
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            border: none;
            transition: all 0.3s;
        }
        
        .btn-send-otp:hover:not(:disabled) {
            transform: scale(1.05);
            box-shadow: 0 3px 10px rgba(44, 90, 160, 0.4);
        }
        
        .btn-verify-otp {
            border-radius: 0 10px 10px 0;
            padding: 12px 20px;
            font-weight: bold;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            transition: all 0.3s;
        }
        
        .btn-verify-otp:hover:not(:disabled) {
            transform: scale(1.05);
            box-shadow: 0 3px 10px rgba(40, 167, 69, 0.4);
        }
        
        .btn-register {
            background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: bold;
            font-size: 16px;
            transition: transform 0.3s;
        }
        
        .btn-register:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(44, 90, 160, 0.5);
        }
        
        .btn-register:disabled {
            background: linear-gradient(135deg, #ccc 0%, #999 100%);
            cursor: not-allowed;
        }
        
        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        
        .login-link a {
            color: #2c5aa0;
            text-decoration: none;
            font-weight: bold;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .verified-badge {
            color: #28a745;
            font-weight: bold;
            margin-top: 5px;
            display: block;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h2> <i class="fas fa-book-reader"></i> Đăng Ký Tài Khoản </h2>
            <p>Tạo tài khoản để trải nghiệm mua sắm sách tuyệt vời</p>
        </div>
        
        <form action="register" method="post" id="registerForm">
            <c:if test="${not empty redirectParam}">
                <input type="hidden" name="redirect" value="${redirectParam}">
            </c:if>
            
            <!-- Username -->
            <div class="mb-3">
                <label class="form-label">Username <span class="text-danger">*</span></label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                    <input type="text" class="form-control" name="username" id="username"
                           placeholder="Nhập username" 
                           value="${username != null ? username : ''}">
                </div>
            </div>
            
            <!-- Email + Nút Gửi Mã -->
            <div class="mb-3">
                <label class="form-label">Email <span class="text-danger">*</span></label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                    <input type="email" class="form-control" name="email" id="email"
                           placeholder="Nhập email"
                           value="${email != null ? email : ''}">
                    <button type="button" class="btn btn-primary btn-send-otp" id="btnSendOtp" onclick="sendOtp()">
                        Gửi mã
                    </button>
                </div>
                <small id="emailVerifiedStatus" class="verified-badge" style="display: none;">
                    <i class="fas fa-check-circle"></i> Email đã xác minh
                </small>
            </div>
            
            <!-- OTP + Nút Xác Minh -->
            <div class="mb-3">
                <label class="form-label">Mã OTP <span class="text-danger">*</span></label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-key"></i></span>
                    <input type="text" class="form-control" id="otp" placeholder="Nhập mã OTP (6 số)" maxlength="6">
                    <button type="button" class="btn btn-success btn-verify-otp" id="btnVerifyOtp" onclick="verifyOtp()">
                        Xác minh
                    </button>
                </div>
            </div>
            
            <!-- Password -->
            <div class="mb-3">
                <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                    <input type="password" class="form-control" name="password" id="password"
                           placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)">
                </div>
            </div>
            
            <!-- Full Name -->
            <div class="mb-3">
                <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                    <input type="text" class="form-control" name="fullName" id="fullName"
                           placeholder="Nhập họ và tên"
                           value="${fullName != null ? fullName : ''}">
                </div>
            </div>
            
            <!-- Phone -->
            <div class="mb-3">
                <label class="form-label">Số điện thoại</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-phone"></i></span>
                    <input type="text" class="form-control" name="phone" id="phone"
                           placeholder="Nhập số điện thoại"
                           value="${phone != null ? phone : ''}">
                </div>
            </div>
            
            <!-- Address -->
            <div class="mb-3">
                <label class="form-label">Địa chỉ</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
                    <input type="text" class="form-control" name="address" id="address"
                           placeholder="Nhập địa chỉ"
                           value="${address != null ? address : ''}">
                </div>
            </div>
            
            <!-- Submit Button (disabled mặc định) -->
            <button type="submit" class="btn btn-primary btn-register w-100" id="btnRegister" disabled>
                <i class="fas fa-user-plus"></i> Đăng Ký
            </button>
        </form>
        
        <div class="login-link">
            Đã có tài khoản? 
            <c:choose>
                <c:when test="${not empty redirectParam}">
                    <a href="login?redirect=${redirectParam}">Đăng nhập ngay</a>
                </c:when>
                <c:otherwise>
                    <a href="login">Đăng nhập ngay</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        let emailVerified = false;
        
        // Gửi OTP
        function sendOtp() {
            const email = document.getElementById('email').value.trim();
            
            if (email === "") {
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Vui lòng nhập email!', timer: 1800, showConfirmButton: false});
                return;
            }
            
            if (!/^\S+@\S+\.\S+$/.test(email)) {
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Email không hợp lệ!', timer: 1800, showConfirmButton: false});
                return;
            }
            
            // Gửi AJAX
            fetch('send-otp', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'email=' + encodeURIComponent(email)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    Swal.fire({icon: 'success', title: 'Thành công', text: data.message, timer: 2000, showConfirmButton: false});
                } else {
                    Swal.fire({icon: 'error', title: 'Lỗi', text: data.message, timer: 2000, showConfirmButton: false});
                }
            })
            .catch(error => {
                Swal.fire({icon: 'error', title: 'Lỗi', text: 'Không thể gửi OTP!', timer: 2000, showConfirmButton: false});
            });
        }
        
        // Xác minh OTP
        function verifyOtp() {
            const otp = document.getElementById('otp').value.trim();
            
            if (otp === "" || otp.length !== 6) {
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Vui lòng nhập đúng mã OTP 6 số!', timer: 1800, showConfirmButton: false});
                return;
            }
            
            // Gửi AJAX
            fetch('verify-otp', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'otp=' + encodeURIComponent(otp)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    emailVerified = true;
                    document.getElementById('email').readOnly = true;
                    document.getElementById('btnSendOtp').disabled = true;
                    document.getElementById('btnVerifyOtp').disabled = true;
                    document.getElementById('btnRegister').disabled = false;
                    document.getElementById('emailVerifiedStatus').style.display = 'block';
                    Swal.fire({icon: 'success', title: 'Xác minh thành công!', text: data.message, timer: 2000, showConfirmButton: false});
                } else {
                    Swal.fire({icon: 'error', title: 'Lỗi', text: data.message, timer: 2000, showConfirmButton: false});
                }
            })
            .catch(error => {
                Swal.fire({icon: 'error', title: 'Lỗi', text: 'Không thể xác minh OTP!', timer: 2000, showConfirmButton: false});
            });
        }
        
        // Khi email thay đổi sau khi đã verify → reset
        document.getElementById('email').addEventListener('input', function() {
            if (emailVerified) {
                Swal.fire({icon: 'info', title: 'Thông báo', text: 'Email đã thay đổi, vui lòng xác minh lại!', timer: 1800, showConfirmButton: false});
                emailVerified = false;
                document.getElementById('email').readOnly = false;
                document.getElementById('btnSendOtp').disabled = false;
                document.getElementById('btnVerifyOtp').disabled = false;
                document.getElementById('btnRegister').disabled = true;
                document.getElementById('emailVerifiedStatus').style.display = 'none';
            }
        });
        
        // Hiển thị lỗi (nếu có)
        <c:if test="${not empty errorMessage}">
            Swal.fire({
                icon: 'error',
                title: 'Lỗi!',
                text: '${errorMessage}',
                confirmButtonText: 'Thử lại',
                confirmButtonColor: '#d33'
            });
        </c:if>
        
        // Hiển thị thành công và redirect
        <c:if test="${registerSuccess == 'true'}">
            Swal.fire({
                icon: 'success',
                title: 'Đăng ký thành công!',
                text: 'Chào mừng bạn đến với Bookstore!',
                timer: 2000,
                showConfirmButton: false
            }).then(() => {
                window.location.href = '${redirectUrl}';
            });
        </c:if>
        
        // Validate form trước khi submit
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            if (!emailVerified) {
                e.preventDefault();
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Vui lòng xác minh email trước khi đăng ký!', timer: 1800, showConfirmButton: false});
                return false;
            }
            
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            const fullName = document.getElementById('fullName').value.trim();
            
            if (username === "") {
                e.preventDefault();
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Vui lòng nhập username!', timer: 1800, showConfirmButton: false});
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Mật khẩu phải có ít nhất 6 ký tự!', timer: 1800, showConfirmButton: false});
                return false;
            }
            
            if (fullName === "") {
                e.preventDefault();
                Swal.fire({icon: 'warning', title: 'Lỗi', text: 'Vui lòng nhập họ và tên!', timer: 1800, showConfirmButton: false});
                return false;
            }
            
            return true;
        });
        
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
