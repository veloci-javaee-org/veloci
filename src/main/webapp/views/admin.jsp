<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Admin Dashboard | Veloci</title>
<style>
* {
	box-sizing: border-box
}

body {
	margin: 0;
	background: #f7f7f5;
	color: #171717;
	font: 16px Arial, Helvetica, sans-serif
}

a {
	color: inherit;
	text-decoration: none
}

.navbar {
	height: 72px;
	padding: 0 7%;
	display: flex;
	align-items: center;
	justify-content: space-between;
	background: #fff;
	border-bottom: 1px solid #eee
}

.logo {
	font-size: 27px;
	font-weight: 800;
	letter-spacing: -1px
}

.logo span {
	font-weight: 400
}

.admin-badge {
	padding: 6px 12px;
	border-radius: 20px;
	background: #171717;
	color: #fff;
	font-size: 11px;
	font-weight: 700;
	letter-spacing: 1px;
	text-transform: uppercase
}

main {
	max-width: 1100px;
	margin: 0 auto;
	padding: 56px 24px
}

h1 {
	margin: 0 0 10px;
	font-size: 42px;
	letter-spacing: -2px
}

.intro {
	margin: 0 0 34px;
	color: #666;
	line-height: 1.6
}

.grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
	gap: 18px
}

.card {
	display: block;
	padding: 26px;
	background: #fff;
	border: 1px solid #eee;
	border-radius: 12px;
	transition: .2s
}

.card:hover {
	transform: translateY(-3px);
	box-shadow: 0 12px 28px #17171712
}

.card h2 {
	margin: 0 0 10px;
	font-size: 21px
}

.card p {
	margin: 0;
	color: #666;
	line-height: 1.6
}

.card span {
	display: inline-block;
	margin-top: 20px;
	font-weight: 700;
	border-bottom: 1px solid #171717;
	padding-bottom: 3px
}

.toolbar {
	display: flex;
	justify-content: flex-end;
	margin-top: 28px
}

button {
	padding: 11px 17px;
	border: 1px solid #ccc;
	border-radius: 7px;
	background: #fff;
	font: inherit;
	cursor: pointer
}

@media ( max-width :600px) {
	.navbar {
		padding: 0 20px
	}
	main {
		padding-top: 38px
	}
	h1 {
		font-size: 34px
	}
}
</style>
</head>
<body>
	<header class="navbar">
		<a class="logo" href="${pageContext.request.contextPath}/index.jsp">velo<span>ci</span></a>
		<span class="admin-badge">Admin</span>
	</header>
	<main>
		<h1>Admin dashboard</h1>
		<p class="intro">
			Welcome,
			<c:out value="${sessionScope.name}" />
			. Manage the store from here.
		</p>
		<section class="grid" aria-label="Store management">
			<a class="card"
				href="${pageContext.request.contextPath}/admin/products">
				<h2>Product management</h2>
				<p>View, add, edit, and delete products in the storefront
					catalogue.</p> <span>Manage products</span>
			</a> <a class="card"
				href="${pageContext.request.contextPath}/admin/categories">
				<h2>Category management</h2>
				<p>View, add, edit, and delete product categories.</p> <span>Manage
					categories</span>
			</a>
		</section>
		<div class="toolbar">
			<form action="${pageContext.request.contextPath}/logout"
				method="post">
				<button type="submit">Log out</button>
			</form>
		</div>
	</main>
</body>
</html>
