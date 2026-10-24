<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
	crossorigin="anonymous">

<title>Veloci | Shop Smarter</title>

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
}

a {
	text-decoration: none;
	color: inherit;
}

/* ================= NAVBAR ================= */
.navbar {
	height: 72px;
	padding: 0 7%;
	display: flex;
	align-items: center;
	justify-content: space-between;
	background: #ffffff;
	border-bottom: 1px solid #eeeeee;
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
	gap: 32px;
	list-style: none;
	font-size: 14px;
	color: #555;
}

.nav-links a:hover {
	color: #000;
}

.nav-actions {
	display: flex;
	align-items: center;
	gap: 18px;
}

.cart {
	font-size: 14px;
	color: #444;
}

.login-btn {
	padding: 10px 18px;
	border: 1px solid #171717;
	border-radius: 7px;
	font-size: 14px;
}

.login-btn:hover {
	background: #171717;
	color: white;
}

.profile-menu {
	position: relative;
}

.profile-menu summary {
	list-style: none;
	cursor: pointer;
}

.profile-menu summary::-webkit-details-marker {
	display: none;
}

.profile-options {
	position: absolute;
	right: 0;
	top: calc(100% + 10px);
	z-index: 5;
	min-width: 165px;
	padding: 8px;
	background: #fff;
	border: 1px solid #eee;
	border-radius: 9px;
	box-shadow: 0 8px 24px #0002;
}

.profile-options a, .profile-options button {
	display: block;
	width: 100%;
	padding: 10px;
	border: 0;
	background: none;
	text-align: left;
	font: inherit;
	cursor: pointer;
}

.profile-options a:hover, .profile-options button:hover {
	background: #f5f5f2;
}

/* ================= HERO ================= */
.hero {
	min-height: 570px;
	padding: 70px 7%;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 60px;
	background: #e9e8e3;
}

.hero-content {
	max-width: 600px;
}

.hero-label {
	display: inline-block;
	margin-bottom: 22px;
	padding: 8px 13px;
	border-radius: 20px;
	background: #ffffff;
	font-size: 12px;
	font-weight: 600;
	letter-spacing: 1px;
	text-transform: uppercase;
}

.hero h1 {
	font-size: clamp(50px, 6vw, 82px);
	line-height: .95;
	letter-spacing: -4px;
	margin-bottom: 25px;
}

.hero h1 span {
	font-weight: 400;
}

.hero p {
	max-width: 470px;
	color: #555;
	font-size: 17px;
	line-height: 1.7;
	margin-bottom: 32px;
}

.hero-buttons {
	display: flex;
	gap: 12px;
}

.primary-btn {
	background: #171717;
	color: white;
	padding: 14px 25px;
	border-radius: 7px;
	font-size: 14px;
	font-weight: 600;
}

.primary-btn:hover {
	background: #333;
}

.secondary-btn {
	padding: 14px 25px;
	border: 1px solid #aaa;
	border-radius: 7px;
	font-size: 14px;
	font-weight: 600;
	background: rgba(255, 255, 255, .5);
}

.secondary-btn:hover {
	background: white;
}

.hero-image {
	width: 440px;
	height: 440px;
	border-radius: 20px;
	background: #d5d3cb;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden;
}

.hero-image img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.image-placeholder {
	color: #777;
	font-size: 13px;
	text-align: center;
}

/* ================= SECTION ================= */
.section {
	padding: 85px 7%;
}

.section-header {
	display: flex;
	justify-content: space-between;
	align-items: end;
	margin-bottom: 35px;
}

.section-header h2 {
	font-size: 34px;
	letter-spacing: -1px;
}

.section-header p {
	color: #777;
	font-size: 14px;
}

.view-all {
	font-size: 14px;
	font-weight: 600;
	border-bottom: 1px solid #171717;
	padding-bottom: 4px;
}

/* ================= CATEGORIES ================= */
.categories {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 18px;
}

.category {
	height: 190px;
	padding: 25px;
	border-radius: 12px;
	background: white;
	border: 1px solid #eeeeee;
	display: flex;
	flex-direction: column;
	justify-content: end;
	transition: .2s;
}

.category:hover {
	transform: translateY(-4px);
	border-color: #ccc;
}

.category-number {
	font-size: 12px;
	color: #999;
	margin-bottom: auto;
}

.category h3 {
	font-size: 20px;
	margin-bottom: 6px;
}

.category p {
	color: #888;
	font-size: 13px;
}

/* ================= PRODUCTS ================= */
.products {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 20px;
}

.categories.row, .products.row {
	display: flex;
	grid-template-columns: none;
}

.product-card {
	background: white;
	border-radius: 12px;
	overflow: hidden;
	border: 1px solid #eeeeee;
}

.product-image {
	height: 260px;
	background: #eeeeee;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #999;
	font-size: 13px;
}

.product-image img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.product-info {
	padding: 18px;
}

.product-category {
	font-size: 11px;
	color: #999;
	text-transform: uppercase;
	letter-spacing: 1px;
}

.product-name {
	margin: 8px 0;
	font-size: 16px;
	font-weight: 600;
}

.product-bottom {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 15px;
}

.price {
	font-size: 16px;
	font-weight: 700;
}

.add-btn {
	padding: 8px 13px;
	border-radius: 6px;
	background: #171717;
	color: white;
	font-size: 12px;
}

/* ================= BANNER ================= */
.banner {
	margin: 20px 7% 80px;
	padding: 60px;
	border-radius: 16px;
	background: #171717;
	color: white;
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 30px;
}

.banner h2 {
	font-size: 38px;
	letter-spacing: -1px;
	margin-bottom: 12px;
}

.banner p {
	color: #aaa;
	font-size: 15px;
}

.banner-btn {
	background: white;
	color: #171717;
	padding: 14px 24px;
	border-radius: 7px;
	font-size: 14px;
	font-weight: 600;
	white-space: nowrap;
}

/* ================= FOOTER ================= */
footer {
	padding: 50px 7%;
	background: #ffffff;
	border-top: 1px solid #eeeeee;
	display: flex;
	justify-content: space-between;
	gap: 40px;
}

.footer-brand h2 {
	margin-bottom: 10px;
}

.footer-brand p {
	color: #888;
	font-size: 13px;
}

.footer-links {
	display: flex;
	gap: 60px;
}

.footer-column h4 {
	font-size: 13px;
	margin-bottom: 15px;
}

.footer-column a {
	display: block;
	color: #777;
	font-size: 13px;
	margin-bottom: 9px;
}

.footer-column a:hover {
	color: #111;
}

.copyright {
	padding: 18px 7%;
	background: #ffffff;
	color: #aaa;
	font-size: 12px;
	border-top: 1px solid #eeeeee;
}

/* ================= RESPONSIVE ================= */
@media ( max-width : 900px) {
	.nav-links {
		display: none;
	}
	.hero {
		flex-direction: column;
		align-items: flex-start;
	}
	.hero-image {
		width: 100%;
		height: 350px;
	}
	.categories, .products {
		grid-template-columns: repeat(2, 1fr);
	}
	.banner {
		flex-direction: column;
		align-items: flex-start;
	}
}

@media ( max-width : 600px) {
	.navbar {
		padding: 0 5%;
	}
	.hero, .section {
		padding-left: 5%;
		padding-right: 5%;
	}
	.hero h1 {
		font-size: 52px;
	}
	.categories, .products {
		grid-template-columns: 1fr;
	}
	.banner {
		margin-left: 5%;
		margin-right: 5%;
		padding: 35px;
	}
	footer {
		flex-direction: column;
	}
	.footer-links {
		gap: 30px;
	}
}
</style>
</head>

<body>

	<!-- ================= NAVBAR ================= -->

	<header class="navbar">

		<a href="${pageContext.request.contextPath}/home" class="logo">
			velo<span>ci</span>
		</a>

		<ul class="nav-links">
			<li><a href="${pageContext.request.contextPath}/home">Home</a></li>
			<li><a href="${pageContext.request.contextPath}/products">Shop</a></li>
		</ul>

		<div class="nav-actions">
			<%
			if (session.getAttribute("username") != null && "ADMIN".equals(String.valueOf(session.getAttribute("role")))) {
			%>
			<a href="<%=request.getContextPath()%>/admin" class="login-btn">Admin</a>
			<form action="<%=request.getContextPath()%>/logout" method="post">
				<button type="submit" class="login-btn">Log out</button>
			</form>
			<%
			} else if (session.getAttribute("username") != null) {
			%>
			<a href="<%=request.getContextPath()%>/cart" class="cart"
				data-cart-open>Cart<span class="vc-badge" data-cart-count></span></a>
			<details class="profile-menu">
				<summary class="login-btn">Profile</summary>
				<div class="profile-options">
					<a href="<%=request.getContextPath()%>/profile">My profile</a><a
						href="<%=request.getContextPath()%>/orders">My orders</a>
					<form action="<%=request.getContextPath()%>/logout" method="post">
						<button type="submit">Log out</button>
					</form>
				</div>
			</details>
			<%
			} else {
			%><a href="<%=request.getContextPath()%>/login"
				class="login-btn">Login</a>
			<%
			}
			%>
		</div>

	</header>


	<!-- ================= HERO ================= -->

	<section class="hero">

		<div class="hero-content">

			<span class="hero-label">Welcome to Veloci</span>

			<h1>
				Find your <span>style.</span>
			</h1>

			<p>Discover comfortable everyday clothing, thoughtfully selected
				for your style.</p>

			<div class="hero-buttons">
				<a href="${pageContext.request.contextPath}/products"
					class="primary-btn"> Shop Now </a> <a
					href="${pageContext.request.contextPath}/products?category=Clothing"
					class="secondary-btn"> Explore Clothing </a>
			</div>

		</div>

		<div class="hero-image">

			<!-- Replace this with your actual image -->
			<div class="image-placeholder">Veloci Hero Image</div>

		</div>

	</section>


	<!-- ================= CATEGORIES ================= -->

	<section class="section">

		<div class="section-header">

			<div>
				<h2>Shop by category</h2>
				<p>Find exactly what you're looking for.</p>
			</div>

			<a href="${pageContext.request.contextPath}/products"
				class="view-all"> View all </a>

		</div>

		<div class="categories row row-cols-1 row-cols-sm-2 row-cols-lg-4 g-3">
			<c:choose>
				<c:when test="${empty storeCategories}">
					<div class="col">
						<a href="${pageContext.request.contextPath}/products"
							class="category"> <span class="category-number">Shop</span>
						<h3>All products</h3>
							<p>Browse the current collection.</p>
						</a>
					</div>
				</c:when>
				<c:otherwise>
					<c:forEach var="category" items="${storeCategories}"
						varStatus="status">
						<div class="col">
							<a
								href="${pageContext.request.contextPath}/products?category=${category.name}"
								class="category"> <span class="category-number">0${status.count}</span>
								<h3>
									<c:out value="${category.name}" />
								</h3>
								<p>
									<c:out value="${category.description}" />
								</p>
							</a>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>

	</section>


	<!-- ================= FEATURED PRODUCTS ================= -->
	<section class="section" style="padding-top: 10px;">
		<div class="section-header">
			<div>
				<h2>Featured products</h2>
				<p>Explore our current collection.</p>
			</div>
			<a href="${pageContext.request.contextPath}/products"
				class="view-all">Browse all products</a>
		</div>
		<div class="products row row-cols-1 row-cols-sm-2 row-cols-lg-4 g-4">
			<c:forEach var="product" items="${featuredProducts}">
				<div class="col">
					<a class="product-card h-100"
						href="${pageContext.request.contextPath}/product-details?id=${product.id}">
						<div class="product-image">
							<c:choose>
								<c:when test="${not empty product.images}">
									<img
										src="${pageContext.request.contextPath}/${product.images[0].imagePath}"
										alt="${product.name}" loading="lazy">
								</c:when>
								<c:otherwise>Image coming soon</c:otherwise>
							</c:choose>
						</div>
						<div class="product-info">
							<span class="product-category"><c:out
									value="${product.category.name}" /></span>
							<h3 class="product-name">
								<c:out value="${product.name}" />
							</h3>
							<span class="add-btn">$<fmt:formatNumber
									value="${product.price}" pattern="#,##0.00" /> · View details
							</span>
						</div>
					</a>
				</div>
			</c:forEach>
		</div>
	</section>


	<!-- ================= CTA ================= -->

	<section class="banner">

		<div>
			<h2>Ready to find your next favorite?</h2>
			<p>Explore our collection and start shopping today.</p>
		</div>

		<a href="${pageContext.request.contextPath}/products"
			class="banner-btn"> Start Shopping </a>

	</section>


	<!-- ================= FOOTER ================= -->

	<footer>

		<div class="footer-brand">

			<h2>veloci</h2>

			<p>Simple shopping. Better experience.</p>

		</div>

		<div class="footer-links">

			<div class="footer-column">

				<h4>Shop</h4>

				<a href="${pageContext.request.contextPath}/products">All
					Products</a> <a href="${pageContext.request.contextPath}/products">Categories</a>
				<%
				if (session.getAttribute("username") != null && "CUSTOMER".equals(String.valueOf(session.getAttribute("role")))) {
				%><a
					href="<%=request.getContextPath()%>/cart">Cart</a>
				<%
				}
				%>

			</div>

			<div class="footer-column">

				<h4>Account</h4>

				<%
				if (session.getAttribute("username") == null) {
				%><a
					href="<%=request.getContextPath()%>/login">Login</a><a
					href="<%=request.getContextPath()%>/signup">Create Account</a>
				<%
				} else if ("CUSTOMER".equals(String.valueOf(session.getAttribute("role")))) {
				%><a
					href="<%=request.getContextPath()%>/orders">My Orders</a>
				<%
				} else {
				%><a href="<%=request.getContextPath()%>/admin">Admin
					dashboard</a>
				<%
				}
				%>

			</div>

		</div>

	</footer>

	<div class="copyright">© 2026 Veloci. All rights reserved.</div>

	<jsp:include page="/WEB-INF/views/shared/cart-drawer.jsp" />

</body>

</html>