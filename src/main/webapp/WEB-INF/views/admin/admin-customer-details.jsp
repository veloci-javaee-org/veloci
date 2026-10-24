<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Customer Details — Admin | Veloci</title>
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

/* PAGE HEADER */
.page {
	padding: 50px 7%;
	max-width: 1400px;
	margin: 0 auto;
}

.page-header {
	display: flex;
	align-items: center;
	gap: 16px;
	margin-bottom: 32px;
}

.back-btn {
	background: #fff;
	border: 1px solid #ddd;
	padding: 10px 16px;
	border-radius: 8px;
	font-size: 14px;
	color: #555;
	transition: 0.2s;
}

.back-btn:hover {
	background: #eee;
	color: #000;
}

.page-title h1 {
	font-size: 32px;
	letter-spacing: -1px;
}

/* CUSTOMER PROFILE CARD */
.profile-card {
	background: #fff;
	border: 1px solid #eeeeee;
	border-radius: 12px;
	padding: 30px;
	margin-bottom: 40px;
	display: flex;
	gap: 40px;
}

.profile-avatar {
	width: 80px;
	height: 80px;
	background: #f0f0f0;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 32px;
	color: #999;
}

.profile-info {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px 60px;
	width: 100%;
}

.info-group h4 {
	font-size: 12px;
	color: #999;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	margin-bottom: 6px;
}

.info-group p {
	font-size: 15px;
	font-weight: 600;
}

.info-group .icon {
	color: #777;
	margin-right: 8px;
	width: 16px;
	text-align: center;
}

/* TABLE (Order History) */
.section-title {
	font-size: 20px;
	margin-bottom: 16px;
	letter-spacing: -0.5px;
}

.table-wrap {
	background: #fff;
	border: 1px solid #eeeeee;
	border-radius: 12px;
	overflow: hidden;
}

table {
	width: 100%;
	border-collapse: collapse;
}

thead th {
	padding: 13px 20px;
	text-align: left;
	font-size: 11px;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: .8px;
	color: #888;
	border-bottom: 1px solid #eeeeee;
	background: #fafafa;
}

tbody td {
	padding: 16px 20px;
	font-size: 14px;
	border-bottom: 1px solid #f3f3f3;
	vertical-align: middle;
}

tbody tr:last-child td {
	border-bottom: none;
}

tbody tr:hover td {
	background: #fafaf8;
}

.cell-num {
	font-size: 13px;
	font-weight: 700;
	color: #171717;
}

/* BADGES */
.badge {
	display: inline-block;
	padding: 5px 12px;
	border-radius: 20px;
	font-size: 11px;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}
.badge-PENDING { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
.badge-CONFIRMED { background: #cce5ff; color: #004085; border: 1px solid #b8daff; }
.badge-SHIPPED { background: #e2e3e5; color: #383d41; border: 1px solid #d6d8db; }
.badge-DELIVERED { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
.badge-CANCELLED { background: #f8d7da; color: #721c24; border: 1px solid #f5c6c2; }

/* BUTTONS */
.btn-edit {
	background: #f7f7f5;
	color: #171717;
	border: 1px solid #e0e0e0;
	padding: 7px 14px;
	font-size: 13px;
	border-radius: 6px;
	font-weight: 600;
	display: inline-block;
}

.btn-edit:hover {
	background: #efefeb;
}

/* EMPTY STATE */
.empty-state {
	padding: 50px 20px;
	text-align: center;
}

.empty-state .empty-icon {
	font-size: 42px;
	margin-bottom: 16px;
	opacity: .2;
	color: #171717;
}

.empty-state h3 {
	font-size: 18px;
	margin-bottom: 8px;
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
</style>
</head>
<body>

	<!-- NAVBAR -->
	<header class="navbar">
	    <a href="${pageContext.request.contextPath}/home" class="logo">velo<span>ci</span></a>
	    <ul class="nav-links">
	        <li><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/products">Products</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/customers" class="active">Customers</a></li>
	    </ul>
	    <span class="admin-badge">Admin</span>
	</header>

	<div class="page">
		
		<div class="page-header">
			<a href="${pageContext.request.contextPath}/admin/customers" class="back-btn">
				<i class="fa-solid fa-arrow-left"></i> Back to Customers
			</a>
			<div class="page-title">
				<h1>Customer Profile</h1>
			</div>
		</div>

		<!-- CUSTOMER DETAILS CARD -->
		<div class="profile-card">
			<div class="profile-avatar">
				<i class="fa-regular fa-user"></i>
			</div>
			
			<div class="profile-info">
				<div class="info-group">
					<h4>Full Name</h4>
					<p><c:out value="${customer.name}" /></p>
				</div>
				
				<div class="info-group">
					<h4>Customer ID</h4>
					<p>#${customer.id}</p>
				</div>
				
				<div class="info-group">
					<h4>Contact Information</h4>
					<p><i class="fa-regular fa-envelope icon"></i> <c:out value="${customer.email}" /></p>
					<p style="margin-top: 6px;">
						<i class="fa-solid fa-mobile-screen icon"></i> 
						<c:choose>
							<c:when test="${not empty customer.phone}"><c:out value="${customer.phone}" /></c:when>
							<c:otherwise><span style="color:#aaa; font-style:italic;">No phone provided</span></c:otherwise>
						</c:choose>
					</p>
				</div>
				
				<div class="info-group">
					<h4>Registration Date</h4>
					<p><i class="fa-regular fa-calendar icon"></i> <c:out value="${not empty customer.user.formattedRegistrationDate ? customer.user.formattedRegistrationDate : customer.user.registrationDate}" /></p>
				</div>
			</div>
		</div>

		<!-- ORDER HISTORY -->
		<h2 class="section-title">Order History</h2>
		
		<div class="table-wrap">
			<table>
				<thead>
					<tr>
						<th>Order ID</th>
						<th>Date</th>
						<th>Total Amount</th>
						<th>Status</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${empty orders}">
							<tr>
								<td colspan="5">
									<div class="empty-state">
										<div class="empty-icon"><i class="fa-solid fa-box-open"></i></div>
										<h3>No orders yet</h3>
										<p>This customer hasn't placed any orders.</p>
									</div>
								</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="order" items="${orders}">
								<tr>
									<td class="cell-num">#${order.id}</td>
									
									<td style="color: #666;">
										<c:out value="${not empty order.formattedOrderDate ? order.formattedOrderDate : order.orderDate}" />
									</td>
									
									<td style="font-weight: 600;">
										EGP <c:out value="${order.totalPrice}" />
									</td>
									
									<td>
										<!-- Uses the order.status.name() to get the uppercase ENUM value for the badge CSS -->
										<span class="badge badge-${order.status.name()}">
											<c:out value="${order.status.name()}" />
										</span>
									</td>
									
									<td>
										<a class="btn-edit" href="${pageContext.request.contextPath}/admin/order-details?id=${order.id}">View Details</a>
									</td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>

	</div>

	<footer class="page-footer">
		<span>&#169; 2026 Veloci Admin Panel</span>
	</footer>

</body>
</html>