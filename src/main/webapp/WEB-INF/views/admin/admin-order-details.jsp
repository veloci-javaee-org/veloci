<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Details — Admin | Veloci</title>
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

.page-title p {
	color: #777;
	font-size: 14px;
	margin-top: 4px;
}

/* LAYOUT GRID */
.details-layout {
	display: grid;
	grid-template-columns: 2.5fr 1fr;
	gap: 24px;
	align-items: start;
}

.card {
	background: #fff;
	border: 1px solid #eeeeee;
	border-radius: 12px;
	padding: 24px;
	margin-bottom: 24px;
}

.card-title {
	font-size: 18px;
	font-weight: 700;
	margin-bottom: 20px;
	padding-bottom: 12px;
	border-bottom: 1px solid #f0f0f0;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

/* TABLE (Order Items) */
table {
	width: 100%;
	border-collapse: collapse;
}

thead th {
	text-align: left;
	font-size: 11px;
	text-transform: uppercase;
	color: #888;
	padding-bottom: 12px;
	border-bottom: 1px solid #eee;
}

tbody td {
	padding: 16px 0;
	border-bottom: 1px solid #f5f5f5;
	vertical-align: top;
}

tbody tr:last-child td {
	border-bottom: none;
}

.product-name {
	font-weight: 600;
	font-size: 15px;
	margin-bottom: 4px;
}

.product-desc {
	font-size: 13px;
	color: #777;
	max-width: 250px;
}

.item-price, .item-qty, .item-total {
	font-size: 14px;
}

.item-total {
	font-weight: 700;
}

.order-total-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 24px;
	padding-top: 24px;
	border-top: 2px solid #eee;
	font-size: 20px;
	font-weight: 800;
}

/* SIDEBAR INFO */
.info-row {
	display: flex;
	align-items: center;
	gap: 12px;
	font-size: 14px;
	color: #444;
	margin-bottom: 16px;
}

.info-icon {
	color: #171717;
	font-size: 16px;
	width: 20px;
	text-align: center;
}

/* UPDATE STATUS FORM */
.status-form {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.status-select {
	padding: 12px;
	border-radius: 8px;
	border: 1px solid #ddd;
	font-size: 15px;
	font-family: inherit;
	background: #fdfdfc;
	cursor: pointer;
	width: 100%;
}

.btn-submit {
	background: #171717;
	color: #fff;
	border: none;
	padding: 12px;
	border-radius: 8px;
	font-size: 14px;
	font-weight: 700;
	cursor: pointer;
	transition: 0.2s;
}

.btn-submit:hover {
	background: #333;
}

.alert {
	padding: 12px;
	border-radius: 8px;
	font-size: 14px;
	margin-bottom: 24px;
}
.alert-success { background: #f0faf3; color: #1a6b38; border: 1px solid #c3e6cb; }

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
	        <li><a href="${pageContext.request.contextPath}/admin/orders" class="active">Orders</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/customers">Customers</a></li>
	    </ul>
	    <span class="admin-badge">Admin</span>
	</header>

	<div class="page">
		
		<div class="page-header">
			<a href="${pageContext.request.contextPath}/admin/orders" class="back-btn">
				<i class="fa-solid fa-arrow-left"></i> Back
			</a>
			<div class="page-title">
				<h1>Order #${order.id}</h1>
				<p>Placed on <c:out value="${not empty order.formattedOrderDate ? order.formattedOrderDate : order.orderDate}" /></p>
			</div>
		</div>

		<c:if test="${not empty param.msg}">
			<div class="alert alert-success">
				&#10003;&nbsp;&nbsp;<c:out value="${param.msg}" />
			</div>
		</c:if>

		<div class="details-layout">
			
			<!-- LEFT COLUMN: Order Items -->
			<div class="left-col">
				<div class="card">
					<div class="card-title">Items in this Order</div>
					
					<table>
						<thead>
							<tr>
								<th>Product</th>
								<th>Price</th>
								<th>Qty</th>
								<th style="text-align: right;">Total</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${order.orderItems}">
								<tr>
									<td>
										<div class="product-name"><c:out value="${item.product.name}" /></div>
										<div class="product-desc"><c:out value="${item.product.description}" /></div>
									</td>
									<td class="item-price">EGP <c:out value="${item.price}" /></td>
									<td class="item-qty">x<c:out value="${item.quantity}" /></td>
									<td class="item-total" style="text-align: right;">
										EGP <c:out value="${item.price * item.quantity}" />
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>

					<div class="order-total-row">
						<span>Grand Total</span>
						<span>EGP <c:out value="${order.totalPrice}" /></span>
					</div>
				</div>
			</div>

			<!-- RIGHT COLUMN: Sidebar -->
			<div class="right-col">
				
				<!-- Customer Details Card -->
				<div class="card">
					<div class="card-title">Customer Details</div>
					
					<div class="info-row">
						<div class="info-icon"><i class="fa-regular fa-user"></i></div>
						<div>
							<div style="font-weight: 600;"><c:out value="${order.customer.name}" /></div>
							<div style="font-size: 12px; color: #888;">Customer ID: #${order.customer.id}</div>
						</div>
					</div>
					
					<!-- Uncomment if you fixed the address logic in Java -->
					<!--
					<div class="info-row">
						<div class="info-icon"><i class="fa-solid fa-location-dot"></i></div>
						<div><c:out value="${order.customer.address}" /></div>
					</div>
					-->
					
					<a href="${pageContext.request.contextPath}/admin/customer-details?id=${order.customer.id}" 
					   style="display: block; margin-top: 16px; font-size: 13px; color: #0066cc; font-weight: 600;">
					   View Full Profile &rarr;
					</a>
				</div>

				<!-- Status Update Card -->
				<div class="card">
					<div class="card-title">Order Status</div>
					
					<!-- Form sends POST request to update the status -->
					<form action="${pageContext.request.contextPath}/admin/order-details" method="post" class="status-form">
						<input type="hidden" name="id" value="${order.id}">
						<input type="hidden" name="action" value="updateStatus">
						
						<select name="status" class="status-select">
					    <!-- Using .name() converts the Enum to a safe String, preventing EL coercion errors -->
					    <option value="Pending" ${order.status.name() == 'PENDING' ? 'selected' : ''}>Pending</option>
					    <option value="Confirmed" ${order.status.name() == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
					    <option value="Shipped" ${order.status.name() == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
					    <option value="Delivered" ${order.status.name() == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
					    <option value="Cancelled" ${order.status.name() == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
					   </select>

						<button type="submit" class="btn-submit">Update Status</button>
					</form>
				</div>

			</div>
		</div>

	</div>

	<footer class="page-footer">
		<span>&#169; 2026 Veloci Admin Panel</span>
	</footer>

</body>
</html>