<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard - Bookstore</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body {
	background: linear-gradient(135deg, #e3f2fd 0%, #f0f8ff 100%);
	position: relative;
	overflow-x: hidden;
}

.snowflake {
	position: fixed;
	top: -10px;
	z-index: 1;
	color: #b0d4e8;
	font-size: 1em;
	font-family: Arial;
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
	box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
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
	transition: 0.3s;
}

.sidebar a:hover, .sidebar a.active {
	background: rgba(255, 255, 255, 0.2);
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

.header-bar {
	background: white;
	padding: 20px 30px;
	border-radius: 15px;
	box-shadow: 0 5px 20px rgba(44, 90, 160, 0.15);
	margin-bottom: 30px;
}

.stat-card {
	background: white;
	border-radius: 15px;
	padding: 25px;
	box-shadow: 0 5px 20px rgba(44, 90, 160, 0.15);
	transition: 0.3s;
}

.stat-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 10px 30px rgba(44, 90, 160, 0.25);
}

.stat-card .icon {
	font-size: 40px;
	margin-bottom: 15px;
}

.stat-card h3 {
	font-size: 32px;
	font-weight: bold;
	margin: 10px 0;
}

.stat-card p {
	color: #6c757d;
	margin: 0;
}

.card-users {
	border-left: 5px solid #2c5aa0;
}

.card-categories {
	border-left: 5px solid #f093fb;
}

.card-products {
	border-left: 5px solid #4facfe;
}

.card-orders {
	border-left: 5px solid #43e97b;
}

.chart-card, .table-card {
	background: white;
	border-radius: 15px;
	padding: 25px;
	box-shadow: 0 5px 20px rgba(44, 90, 160, 0.15);
	margin-bottom: 30px;
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
			<h4>
				<i class="fas fa-book-open"></i> Bookstore
			</h4>
			<a href="${pageContext.request.contextPath}/admin/dashboard"
				class="active"><i class="fas fa-home"></i> Trang chủ</a> <a
				href="${pageContext.request.contextPath}/admin/users"><i
				class="fas fa-users"></i> Khách hàng</a> <a
				href="${pageContext.request.contextPath}/admin/categories"><i
				class="fas fa-list"></i> Danh mục</a> <a
				href="${pageContext.request.contextPath}/admin/products"><i
				class="fas fa-book"></i> Sản phẩm</a> <a
				href="${pageContext.request.contextPath}/admin/orders"><i
				class="fas fa-shopping-cart"></i> Đơn hàng</a>
			<hr style="border-color: rgba(255, 255, 255, 0.3); margin: 20px 0;">
			<a href="${pageContext.request.contextPath}/home"><i
				class="fas fa-store"></i> Xem Website</a> <a href="#"
				onclick="confirmLogout(event)"><i class="fas fa-sign-out-alt"></i>
				Đăng xuất</a>
		</div>

		<!-- CONTENT -->
		<div class="content-area">
			<div
				class="header-bar d-flex justify-content-between align-items-center">
				<div>
					<h2 class="mb-0">
						<i class="fas fa-chart-line text-primary"></i> Dashboard
					</h2>
					<small class="text-muted">Tổng quan hệ thống</small>
				</div>
				<div>
					<span class="text-muted">Xin chào, </span> <strong>${adminName != null ? adminName : 'Admin'}</strong>
				</div>
			</div>

			<!-- STATISTICS CARDS -->
			<div class="row g-4">
				<div class="col-md-3">
					<div class="stat-card card-users">
						<div class="icon text-primary">
							<i class="fas fa-users"></i>
						</div>
						<h3>${totalUsers}</h3>
						<p>Người dùng</p>
					</div>
				</div>
				<div class="col-md-3">
					<div class="stat-card card-categories">
						<div class="icon" style="color: #f093fb;">
							<i class="fas fa-list"></i>
						</div>
						<h3>${totalCategories}</h3>
						<p>Danh mục</p>
					</div>
				</div>
				<div class="col-md-3">
					<div class="stat-card card-products">
						<div class="icon" style="color: #4facfe;">
							<i class="fas fa-book"></i>
						</div>
						<h3>${totalProducts}</h3>
						<p>Sản phẩm</p>
					</div>
				</div>
				<div class="col-md-3">
					<div class="stat-card card-orders">
						<div class="icon" style="color: #43e97b;">
							<i class="fas fa-shopping-cart"></i>
						</div>
						<h3>${totalOrders}</h3>
						<p>Đơn hàng</p>
					</div>
				</div>
			</div>

			<!-- CHARTS ROW -->
			<div class="row mt-4">
				<div class="col-md-8">
					<div class="chart-card">
						<h5>
							<i class="fas fa-chart-line"></i> Đơn hàng 7 ngày gần đây
						</h5>
						<canvas id="ordersChart" style="height: 300px;"></canvas>
					</div>
				</div>

				<div class="col-md-4">
					<div class="chart-card">
						<h5>
							<i class="fas fa-chart-pie"></i> Phân bố sản phẩm
						</h5>
						<canvas id="categoryChart" style="height: 300px;"></canvas>
					</div>
				</div>
			</div>

			<!-- BAR CHART -->
			<div class="row">
				<div class="col-12">
					<div class="chart-card">
						<h5>
							<i class="fas fa-chart-bar"></i> Top 5 sản phẩm được xem nhiều
							nhất
						</h5>
						<canvas id="viewsChart" height="60"></canvas>
					</div>
				</div>
			</div>

			<!-- TABLES ROW -->
			<div class="row">
				<div class="col-md-6">
					<div class="table-card">
						<h5>
							<i class="fas fa-clock"></i> Đơn hàng gần đây
						</h5>
						<table class="table table-hover">
							<thead>
								<tr>
									<th>Mã ĐH</th>
									<th>Khách hàng</th>
									<th>Tổng tiền</th>
									<th>Trạng thái</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="order" items="${recentOrders}">
									<tr>
										<td><strong>#${order.id}</strong></td>
										<td>${order.user.username}</td>
										<td class="text-success fw-bold"><fmt:formatNumber
												value="${order.totalAmount}" type="number"
												maxFractionDigits="0" groupingUsed="true" />đ</td>
										<td><span class="badge bg-success">${order.status}</span></td>
									</tr>
								</c:forEach>
								<c:if test="${empty recentOrders}">
									<tr>
										<td colspan="4" class="text-center text-muted">Chưa có
											đơn hàng</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				</div>

				<div class="col-md-6">
					<div class="table-card">
						<h5>
							<i class="fas fa-user-plus"></i> Người dùng mới
						</h5>
						<table class="table table-hover">
							<thead>
								<tr>
									<th>Username</th>
									<th>Email</th>
									<th>Ngày đăng ký</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="user" items="${newUsers}">
									<tr>
										<td><strong>${user.username}</strong></td>
										<td>${user.email}</td>
										<td>${user.createdDateFormatted}</td>
									</tr>
								</c:forEach>
								<c:if test="${empty newUsers}">
									<tr>
										<td colspan="3" class="text-center text-muted">Chưa có
											người dùng mới</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				</div>
			</div>

			<!-- TOP SELLING -->
			<div class="row">
				<div class="col-12">
					<div class="table-card">
						<h5>
							<i class="fas fa-fire"></i> Top 3 sản phẩm bán chạy
						</h5>
						<table class="table table-hover">
							<thead>
								<tr>
									<th>Tên sách</th>
									<th>Danh mục</th>
									<th>Đã bán</th>
									<th>Tồn kho</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="product" items="${topSellingProducts}">
									<tr>
										<td><strong>${product[0]}</strong></td>
										<td>${product[1]}</td>
										<td class="text-success fw-bold">${product[2]}cuốn</td>
										<td>${product[3]}</td>
									</tr>
								</c:forEach>
								<c:if test="${empty topSellingProducts}">
									<tr>
										<td colspan="4" class="text-center text-muted">Chưa có
											sản phẩm bán chạy</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				</div>
			</div>

		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

	<script>
<%String msg = (String) session.getAttribute("loginSuccessMessage");
if (msg != null) {
	session.removeAttribute("loginSuccessMessage");%>
Swal.fire({ icon: 'success', title: 'Đăng Nhập Thành Công!', text: '<%=msg%>', timer: 2000, confirmButtonText: 'OK', confirmButtonColor: '#2c5aa0' });
<%}%>

// LOGOUT CONFIRM
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
    }).then((r)=>{ if(r.isConfirmed) window.location='${pageContext.request.contextPath}/logout'; });
}

// ORDERS CHART
const ordersData = { 
<c:forEach var="entry" items="${ordersChartData}" varStatus="s">
'${entry.key}': ${entry.value}<c:if test="${!s.last}">,</c:if>
</c:forEach>
};

new Chart(document.getElementById('ordersChart').getContext('2d'), {
    type: 'line',
    data: { labels: Object.keys(ordersData), datasets: [{ label: 'Số đơn hàng', data: Object.values(ordersData), borderColor:'#2c5aa0', backgroundColor:'rgba(44,90,160,0.1)', fill:true, tension:0.4 }] }
});

// CATEGORY PIE CHART
const categoryData = {
<c:forEach var="entry" items="${categoryChartData}" varStatus="s">
'${entry.key}': ${entry.value}<c:if test="${!s.last}">,</c:if>
</c:forEach>
};

new Chart(document.getElementById('categoryChart').getContext('2d'),{
    type:'pie', data:{ labels:Object.keys(categoryData), datasets:[{ data:Object.values(categoryData), backgroundColor:['#2c5aa0','#f093fb','#4facfe','#43e97b','#ff6b6b'] }] }
});

// VIEWS BAR CHART
const viewsData = {
<c:forEach var="entry" items="${viewsChartData}" varStatus="s">
'${entry.key}': ${entry.value}<c:if test="${!s.last}">,</c:if>
</c:forEach>
};

new Chart(document.getElementById('viewsChart').getContext('2d'),{
    type:'bar',
    data:{ labels:Object.keys(viewsData), datasets:[{ data:Object.values(viewsData), backgroundColor:'#5b9bd5' }] },
    options:{ plugins:{ legend:{ display:false } }, scales:{ y:{ beginAtZero:true } } }
});

// SNOW EFFECT
function createSnowflake(){ const s=document.createElement('div'); s.classList.add('snowflake'); s.innerHTML='❄'; s.style.left=Math.random()*window.innerWidth+'px'; s.style.animationDuration=Math.random()*5+4+'s'; s.style.opacity=Math.random()*.5+.2; s.style.fontSize=Math.random()*20+15+'px'; document.body.appendChild(s); setTimeout(()=>s.remove(),9000);}
setInterval(createSnowflake,250);
</script>

</body>
</html>
