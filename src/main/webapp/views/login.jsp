<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đăng Nhập - Bookstore</title>

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!-- SweetAlert2 -->
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

.login-container {
    background: white;
    border-radius: 20px;
    box-shadow: 0 10px 50px rgba(44, 90, 160, 0.4);
    padding: 50px 40px;
    max-width: 450px;
    width: 100%;
    animation: fadeInUp 0.6s ease-out;
}

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.login-header {
    text-align: center;
    margin-bottom: 40px;
}

.login-icon {
    width: 80px;
    height: 80px;
    background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 20px;
    animation: bounce 1s infinite alternate;
    box-shadow: 0 5px 20px rgba(44, 90, 160, 0.3);
}

@keyframes bounce {
    from {
        transform: translateY(0);
    }
    to {
        transform: translateY(-10px);
    }
}

.login-icon i {
    font-size: 40px;
    color: white;
}

.login-header h2 {
    color: #1e3a5f;
    font-weight: bold;
    margin-bottom: 10px;
}

.login-header p {
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
    padding: 15px 20px;
    border: 2px solid #d0e8f2;
    transition: all 0.3s;
    font-size: 15px;
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
    width: 50px;
    justify-content: center;
}

.input-group .form-control {
    border-left: none;
    border-radius: 0 10px 10px 0;
}

.btn-login {
    background: linear-gradient(135deg, #2c5aa0 0%, #5b9bd5 100%);
    border: none;
    border-radius: 10px;
    padding: 15px;
    font-weight: bold;
    font-size: 16px;
    transition: all 0.3s;
    margin-top: 10px;
}

.btn-login:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 25px rgba(44, 90, 160, 0.5);
}

.register-link {
    text-align: center;
    margin-top: 25px;
    color: #666;
    font-size: 15px;
}

.register-link a {
    color: #2c5aa0;
    text-decoration: none;
    font-weight: bold;
}

.register-link a:hover {
    text-decoration: underline;
}

.divider {
    display: flex;
    align-items: center;
    margin: 25px 0;
    color: #999;
}

.divider::before, .divider::after {
    content: '';
    flex: 1;
    height: 1px;
    background: #d0e8f2;
}

.divider span {
    padding: 0 15px;
    font-size: 13px;
}
</style>
</head>
<body>
<div class="login-container">
    <div class="login-header">
        <div class="login-icon">
            <i class="fas fa-book"></i>
        </div>
        <h2>Chào Mừng Trở Lại!</h2>
        <p>Đăng nhập để tiếp tục mua sắm</p>
    </div>

    <form action="login" method="post">
        <!-- THÊM HIDDEN INPUT để giữ redirect param -->
        <c:if test="${not empty redirectParam}">
            <input type="hidden" name="redirect" value="${redirectParam}">
        </c:if>

        <!-- Username -->
        <div class="mb-3">
            <label class="form-label">Username</label>
            <div class="input-group">
                <span class="input-group-text">
                    <i class="fas fa-user"></i>
                </span>
                <input type="text" class="form-control" name="username" placeholder="Nhập username" autofocus>
            </div>
        </div>

        <!-- Password -->
        <div class="mb-3">
            <label class="form-label">Mật khẩu</label>
            <div class="input-group">
                <span class="input-group-text">
                    <i class="fas fa-lock"></i>
                </span>
                <input type="password" class="form-control" name="password" placeholder="Nhập mật khẩu">
            </div>
        </div>

        <!-- Submit Button -->
        <button type="submit" class="btn btn-primary btn-login w-100">
            <i class="fas fa-sign-in-alt"></i> Đăng Nhập
        </button>
    </form>

    <div class="divider">
        <span>hoặc</span>
    </div>

    <div class="register-link">
        Chưa có tài khoản?
        <c:choose>
            <c:when test="${not empty redirectParam}">
                <a href="register?redirect=${redirectParam}"><i class="fas fa-user-plus"></i> Đăng ký ngay</a>
            </c:when>
            <c:otherwise>
                <a href="register"><i class="fas fa-user-plus"></i> Đăng ký ngay</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Popup lỗi
    <%String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage != null) {%>
        Swal.fire({
            icon: 'error',
            title: 'Lỗi!',
            text: '<%=errorMessage%>',
            confirmButtonText: 'Thử lại',
            confirmButtonColor: '#d33'
        });
    <%}%>
    
    // Popup đăng nhập thành công
    <% if (session.getAttribute("loginSuccess") != null) { 
        String redirectUrl = (String) session.getAttribute("redirectUrl");
        session.removeAttribute("loginSuccess");
        session.removeAttribute("redirectUrl");
    %>
        Swal.fire({
            icon: 'success',
            title: 'Đăng Nhập Thành Công!',
            text: 'Chào mừng <%= session.getAttribute("username") %>! 🎉',
            confirmButtonText: 'OK',
            confirmButtonColor: '#2c5aa0',
            allowOutsideClick: false
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '<%= redirectUrl %>';
            }
        });
    <% } %>
    
    // Popup đăng ký thành công (từ register)
    <%String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {%>
        Swal.fire({
            icon: 'success',
            title: 'Thành Công!',
            text: '<%=successMessage%>',
            confirmButtonText: 'OK',
            confirmButtonColor: '#2c5aa0',
            timer: 3000
        });
        <%session.removeAttribute("successMessage");%>
    <%}%>
    
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
