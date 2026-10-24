<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Customers — Admin | Veloci</title>
<!-- Font Awesome for modern icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: Arial, Helvetica, sans-serif;
	color: #171717;
	background: #f7f7f5;
	min-height: 100vh;
}

a {
	text-decoration: none;
	color: inherit;
}

/* NAVBAR */
.navbar {
	height: 72px;
	padding: 0 7%;
	display: flex;
	align-items: center;
	justify-content: space-between;
	background: #ffffff;
	border-bottom: 1px solid #eeeeee;
	position: sticky;
	top: 0;
	z-index: 10;
}

.logo {
	font-size: 27px;
	font-weight: 800;
	letter-spacing: -1px;
}

.logo span {
	font-weight: 400;
}

.nav-links {
	display: flex;
	gap: 28px;
	list-style: none;
	font-size: 14px;
	color: #555;
}

.nav-links a:hover {
	color: #000;
}

.nav-links .active {
	color: #171717;
	font-weight: 700;
	border-bottom: 2px solid #171717;
	padding-bottom: 2px;
}

.admin-badge {
	font-size: 11px;
	font-weight: 600;
	letter-spacing: 1px;
	text-transform: uppercase;
	padding: 5px 11px;
	border-radius: 20px;
	background: #171717;
	color: #fff;
}

/* PAGE */
.page {
	padding: 50px 7%;
}

.page-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-end;
	margin-bottom: 32px;
}

.page-header-left h1 {
	font-size: 34px;
	letter-spacing: -1px;
	margin-bottom: 6px;
}

.page-header-left p {
	color: #777;
	font-size: 14px;
}

/* STATS */
.stats-row {
	display: flex;
	gap: 16px;
	margin-bottom: 28px;
}

.stat-card {
	background: #fff;
	border: 1px solid #eeeeee;
	border-radius: 12px;
	padding: 20px 28px;
}

.stat-label {
	font-size: 12px;
	color: #999;
	text-transform: uppercase;
	letter-spacing: 1px;
	margin-bottom: 6px;
}

.stat-value {
	font-size: 30px;
	font-weight: 800;
	letter-spacing: -1px;
}

/* GRID & CARDS (Customers specific) */
.customers-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
	gap: 24px;
}

.card {
	background: #fff;
	border: 1px solid #eeeeee;
	border-radius: 12px;
	padding: 24px;
	display: flex;
	flex-direction: column;
	gap: 12px;
	transition: .15s;
}

.card:hover {
	border-color: #d0d0d0;
	box-shadow: 0 4px 12px rgba(0,0,0,0.03);
	transform: translateY(-2px);
}

.card-header {
	display: flex;
	justify-content: space-between;
	align-items: baseline;
	border-bottom: 1px solid #f3f3f3;
	padding-bottom: 16px;
	margin-bottom: 4px;
}

.customer-name {
	font-size: 18px;
	font-weight: 700;
}

.customer-id {
	font-size: 12px;
	color: #999;
	font-weight: 600;
}

.detail-row {
	display: flex;
	align-items: center;
	gap: 12px;
	font-size: 14px;
	color: #555;
}

.detail-icon {
	color: #171717; 
	opacity: 1;    
	font-size: 16px;
	width: 16px;
	text-align: center;
}

/* EMPTY STATE */
.empty-state {
	grid-column: 1 / -1;
	background: #fff;
	border: 1px solid #eeeeee;
	border-radius: 12px;
	padding: 70px 20px;
	text-align: center;
}

.empty-state .empty-icon {
	font-size: 42px;
	margin-bottom: 16px;
	opacity: .2;
}

.empty-state h3 {
	font-size: 20px;
	margin-bottom: 8px;
	letter-spacing: -.5px;
}

.empty-state p {
	color: #888;
	font-size: 14px;
}

/* FOOTER */
.page-footer {
	padding: 28px 7%;
	background: #fff;
	border-top: 1px solid #eee;
	margin-top: 80px;
}

.page-footer span {
	font-size: 13px;
	color: #aaa;
}
</style>
</head>
<body>

	<!-- NAVBAR -->
	<header class="navbar">
	    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">velo<span>ci</span></a>
	    <ul class="nav-links">
	        <li><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/products">Products</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/customers" class="active">Customers</a></li>
	    </ul>
	    <span class="admin-badge">Admin</span>
	</header>

	<!-- PAGE -->
	<div class="page">

		<div class="page-header">
			<div class="page-header-left">
				<h1>Customers</h1>
				<p>View and manage registered store accounts.</p>
			</div>
		</div>

		<div class="stats-row">
			<div class="stat-card">
				<div class="stat-label">Total Customers</div>
				<div class="stat-value">
					<c:choose>
						<c:when test="${not empty customers}">${customers.size()}</c:when>
						<c:otherwise>0</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>

		<div class="customers-grid">
			<c:choose>
				<c:when test="${empty customers}">
					<div class="empty-state">
						<div class="empty-icon"><i class="fa-regular fa-user"></i></div>
						<h3>No customers yet</h3>
						<p>Customers will appear here once they register.</p>
					</div>
				</c:when>
				<c:otherwise>
					<c:forEach var="customer" items="${customers}">
						<!-- Clickable Card linking to customer-details -->
						<a href="${pageContext.request.contextPath}/admin/customer-details?id=${customer.id}" class="card">
							
							<div class="card-header">
								<span class="customer-name"><c:out value="${customer.name}" /></span>
								<span class="customer-id">#ID-${customer.id}</span>
							</div>

							<div class="detail-row">
    							<span class="detail-icon"><i class="fa-regular fa-envelope"></i></span> 
    							<span><c:out value="${customer.email}" /></span>
							</div>

							<div class="detail-row">
							    <span class="detail-icon"><i class="fa-solid fa-mobile-screen"></i></span> 
							    <span>
							        <c:choose>
							            <c:when test="${empty customer.phone}">
							                <span style="color:#ccc; font-style:italic;">No phone provided</span>
							            </c:when>
							            <c:otherwise>
							                <c:out value="${customer.phone}" />
							            </c:otherwise>
							        </c:choose>
							    </span>
							</div>

							<div class="detail-row">
							    <span class="detail-icon"><i class="fa-regular fa-calendar"></i></span> 
							    <span><c:out value="${not empty customer.user.formattedRegistrationDate ? customer.user.formattedRegistrationDate : customer.user.registrationDate}" /></span>
							</div>

						</a>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>

	</div>

	<footer class="page-footer">
		<span>&#169; 2026 Veloci Admin Panel</span>
	</footer>

</body>
</html>