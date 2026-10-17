<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<title><c:choose>
		<c:when test="${not empty category && category.id != 0}">Edit Category</c:when>
		<c:otherwise>Add Category</c:otherwise>
	</c:choose> — Admin | Veloci</title>
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

/* BREADCRUMB */
.breadcrumb {
	display: flex;
	align-items: center;
	gap: 8px;
	font-size: 13px;
	color: #aaa;
	margin-bottom: 28px;
}

.breadcrumb a {
	color: #555;
}

.breadcrumb a:hover {
	color: #171717;
	border-bottom: 1px solid #171717;
}

.breadcrumb .sep {
	color: #ddd;
}

.breadcrumb .current {
	color: #171717;
	font-weight: 600;
}

/* LAYOUT: two-column on wide screens */
.form-layout {
	display: grid;
	grid-template-columns: 1fr 340px;
	gap: 24px;
	align-items: start;
}

/* CARD */
.card {
	background: #fff;
	border: 1px solid #eeeeee;
	border-radius: 12px;
	padding: 32px 36px;
}

.card-title {
	font-size: 18px;
	font-weight: 800;
	letter-spacing: -.5px;
	margin-bottom: 4px;
}

.card-sub {
	font-size: 13px;
	color: #999;
	margin-bottom: 28px;
}

.divider {
	border: none;
	border-top: 1px solid #f0f0f0;
	margin: 24px 0;
}

/* FORM FIELDS */
.field {
	margin-bottom: 20px;
}

.field label {
	display: block;
	font-size: 13px;
	font-weight: 700;
	color: #444;
	margin-bottom: 7px;
}

.field .hint {
	font-size: 12px;
	color: #aaa;
	margin-top: 5px;
}

input[type=text], textarea {
	width: 100%;
	padding: 11px 14px;
	border: 1px solid #e0e0e0;
	border-radius: 7px;
	font-size: 14px;
	font-family: inherit;
	color: #171717;
	background: #fff;
	transition: border-color .15s, box-shadow .15s;
	outline: none;
}

input[type=text]:focus, textarea:focus {
	border-color: #171717;
	box-shadow: 0 0 0 3px rgba(23, 23, 23, .07);
}

textarea {
	height: 110px;
	resize: vertical;
}

.required {
	color: #c0392b;
	margin-left: 2px;
}

/* ALERT */
.alert {
	padding: 13px 18px;
	border-radius: 8px;
	font-size: 14px;
	margin-bottom: 22px;
}

.alert-error {
	background: #fdf0ef;
	color: #922b21;
	border: 1px solid #f5c6c2;
}

/* BUTTONS */
.btn-row {
	display: flex;
	gap: 10px;
	margin-top: 26px;
}

.btn {
	display: inline-block;
	padding: 12px 22px;
	border-radius: 7px;
	font-size: 14px;
	font-weight: 600;
	cursor: pointer;
	border: none;
	transition: .15s;
	text-decoration: none;
	font-family: inherit;
}

.btn-dark {
	background: #171717;
	color: #fff;
}

.btn-dark:hover {
	background: #333;
}

.btn-outline {
	background: #fff;
	color: #555;
	border: 1px solid #d0d0d0;
}

.btn-outline:hover {
	border-color: #171717;
	color: #171717;
}

/* SIDEBAR INFO CARD */
.info-card {
	background: #fff;
	border: 1px solid #eeeeee;
	border-radius: 12px;
	padding: 24px 28px;
}

.info-card h4 {
	font-size: 13px;
	font-weight: 700;
	margin-bottom: 14px;
	color: #555;
	text-transform: uppercase;
	letter-spacing: .8px;
}

.info-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 10px 0;
	border-bottom: 1px solid #f5f5f5;
	font-size: 13px;
}

.info-row:last-child {
	border-bottom: none;
}

.info-row .info-label {
	color: #999;
}

.info-row .info-value {
	font-weight: 600;
}

/* TIP CARD */
.tip-card {
	background: #f7f7f5;
	border: 1px solid #ebebeb;
	border-radius: 12px;
	padding: 20px 24px;
	margin-top: 16px;
}

.tip-card h4 {
	font-size: 12px;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: .8px;
	color: #aaa;
	margin-bottom: 10px;
}

.tip-card ul {
	padding-left: 16px;
}

.tip-card li {
	font-size: 13px;
	color: #666;
	margin-bottom: 7px;
	line-height: 1.5;
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

@media ( max-width : 900px) {
	.form-layout {
		grid-template-columns: 1fr;
	}
}
</style>
</head>
<body>

	<!-- NAVBAR -->
	<header class="navbar">
		<a href="${pageContext.request.contextPath}/admin" class="logo">velo<span>ci</span></a>
		<ul class="nav-links">
			<li><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
			<li><a
				href="${pageContext.request.contextPath}/admin/categories"
				class="active">Categories</a></li>
			<li><a href="${pageContext.request.contextPath}/products">Store
					catalog</a></li>
		</ul>
		<span class="admin-badge">Admin</span>
	</header>

	<!-- PAGE -->
	<div class="page">

		<!-- Breadcrumb -->
		<div class="breadcrumb">
			<a href="${pageContext.request.contextPath}/admin/categories">Categories</a>
			<span class="sep">&#8250;</span> <span class="current"> <c:choose>
					<c:when test="${not empty category && category.id != 0}">Edit — ${category.name}</c:when>
					<c:otherwise>Add New</c:otherwise>
				</c:choose>
			</span>
		</div>

		<!-- Error alert -->
		<c:if test="${not empty error}">
			<div class="alert alert-error">&#10005;&nbsp;&nbsp;${error}</div>
		</c:if>

		<div class="form-layout">

			<!-- LEFT: Form card -->
			<div class="card">

				<div class="card-title">
					<c:choose>
						<c:when test="${not empty category && category.id != 0}">Edit Category</c:when>
						<c:otherwise>New Category</c:otherwise>
					</c:choose>
				</div>
				<div class="card-sub">
					<c:choose>
						<c:when test="${not empty category && category.id != 0}">Update the name or description below.</c:when>
						<c:otherwise>Fill in the details to create a new product category.</c:otherwise>
					</c:choose>
				</div>

				<form action="${pageContext.request.contextPath}/admin/categories"
					method="post">

					<input type="hidden" name="id"
						value="${not empty category ? category.id : 0}">

					<div class="field">
						<label for="name">Category Name <span class="required">*</span></label>
						<input type="text" id="name" name="name" maxlength="100" required
							placeholder="e.g. Electronics, Clothing, Books"
							value="<c:out value='${category.name}'/>">
						<div class="hint">Max 100 characters. Must be unique across
							all categories.</div>
					</div>

					<hr class="divider">

					<div class="field">
						<label for="description">Description</label>
						<textarea id="description" name="description"
							placeholder="Optional — briefly describe what products belong in this category."><c:out
								value="${category.description}" /></textarea>
						<div class="hint">Shown to customers browsing by category.</div>
					</div>

					<div class="btn-row">
						<button class="btn btn-dark" type="submit">
							<c:choose>
								<c:when test="${not empty category && category.id != 0}">Save Changes</c:when>
								<c:otherwise>Add Category</c:otherwise>
							</c:choose>
						</button>
						<a class="btn btn-outline"
							href="${pageContext.request.contextPath}/admin/categories">
							Cancel </a>
					</div>

				</form>

			</div>

			<!-- RIGHT: Sidebar -->
			<div>

				<!-- Only show the info card when editing an existing category -->
				<c:if test="${not empty category && category.id != 0}">
					<div class="info-card">
						<h4>Category Info</h4>
						<div class="info-row">
							<span class="info-label">ID</span> <span class="info-value">#${category.id}</span>
						</div>
						<div class="info-row">
							<span class="info-label">Name</span> <span class="info-value">${category.name}</span>
						</div>
					</div>
				</c:if>

				<div class="tip-card">
					<h4>Tips</h4>
					<ul>
						<li>Use clear, descriptive names customers will recognise.</li>
						<li>Keep names short — one or two words work best.</li>
						<li>Deleting a category won't delete its products; they'll
							become uncategorized.</li>
						<li>Names must be unique — duplicates will be rejected.</li>
					</ul>
				</div>

			</div>

		</div>

	</div>

	<footer class="page-footer">
		<span>&#169; 2026 Veloci Admin Panel</span>
	</footer>

</body>
</html>