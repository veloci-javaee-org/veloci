<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Orders — Admin | Veloci</title>
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

/* TABLE */
.table-wrap {
	background: #fff;
	border: 1px solid #eeeeee;
	border-radius: 12px;
	overflow: hidden;
}

.table-toolbar {
	padding: 16px 22px;
	border-bottom: 1px solid #eeeeee;
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.table-toolbar span {
	font-size: 13px;
	color: #999;
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

/* STATUS BADGES */
.badge {
	display: inline-block;
	padding: 5px 12px;
	border-radius: 20px;
	font-size: 11px;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}
.badge-Pending { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
.badge-Confirmed { background: #cce5ff; color: #004085; border: 1px solid #b8daff; }
.badge-Shipped { background: #e2e3e5; color: #383d41; border: 1px solid #d6d8db; }
.badge-Delivered { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
.badge-Cancelled { background: #f8d7da; color: #721c24; border: 1px solid #f5c6c2; }

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
	padding: 70px 20px;
	text-align: center;
}

.empty-state .empty-icon {
	font-size: 42px;
	margin-bottom: 16px;
	opacity: .2;
	color: #171717;
}

.empty-state h3 {
	font-size: 20px;
	margin-bottom: 8px;
	letter-spacing: -.5px;
}

.empty-state p {
	color: #888;
	font-size: 14px;
	margin-bottom: 22px;
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
	        <li><a href="${pageContext.request.contextPath}/admin/orders" class="active">Orders</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/customers">Customers</a></li>
	    </ul>
	    <span class="admin-badge">Admin</span>
	</header>

	<!-- PAGE -->
	<div class="page">

		<div class="page-header">
			<div class="page-header-left">
				<h1>Orders</h1>
				<p>Manage customer orders and update shipping statuses.</p>
			</div>
		</div>

		<div class="stats-row">
			<div class="stat-card">
				<div class="stat-label">Total Orders</div>
				<div class="stat-value">
					<c:choose>
						<c:when test="${not empty orders}">${orders.size()}</c:when>
						<c:otherwise>0</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>

		<div class="table-wrap">
			<div class="table-toolbar">
				<span>
					<c:choose>
						<c:when test="${not empty orders}">${orders.size()} orders found</c:when>
						<c:otherwise>0 orders</c:otherwise>
					</c:choose>
				</span>
			</div>
			<table>
				<thead>
					<tr>
						<th>Order ID</th>
						<th>Customer ID</th>
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
								<td colspan="6">
									<div class="empty-state">
										<div class="empty-icon"><i class="fa-solid fa-box-open"></i></div>
										<h3>No orders yet</h3>
										<p>When customers place orders, they will appear here.</p>
									</div>
								</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="order" items="${orders}">
								<tr>
									<td class="cell-num">#${order.id}</td>
									
									<td>
										<a href="${pageContext.request.contextPath}/admin/customer-details?id=${order.customer.id}" style="color: #0066cc; font-weight: 600;">
											Cust-${order.customer.id}
										</a>
									</td>
									
									<td style="color: #666;">
										<!-- Assumes you add a getFormattedOrderDate() to Order.java, otherwise falls back to raw date -->
										<c:out value="${not empty order.formattedOrderDate ? order.formattedOrderDate : order.orderDate}" />
									</td>
									
									<td style="font-weight: 600;">
										EGP <c:out value="${order.totalPrice}" />
									</td>
									
									<td>
										<!-- Dynamically applies the CSS class based on the Enum value (e.g. badge-Pending, badge-Delivered) -->
										<span class="badge badge-${order.status}">
											<c:out value="${order.status}" />
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