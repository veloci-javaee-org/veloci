<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Data Issue — Admin | Veloci</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: Arial, Helvetica, sans-serif; color: #171717; background: #f7f7f5; min-height: 100vh; display: flex; flex-direction: column; }
a { text-decoration: none; color: inherit; }

/* NAVBAR */
.navbar { height: 72px; padding: 0 7%; display: flex; align-items: center; justify-content: space-between; background: #ffffff; border-bottom: 1px solid #eeeeee; position: sticky; top: 0; z-index: 10; }
.logo { font-size: 27px; font-weight: 800; letter-spacing: -1px; }
.logo span { font-weight: 400; }
.nav-links { display: flex; gap: 28px; list-style: none; font-size: 14px; color: #555; }
.nav-links a:hover { color: #000; }
.admin-badge { font-size: 11px; font-weight: 600; letter-spacing: 1px; text-transform: uppercase; padding: 5px 11px; border-radius: 20px; background: #171717; color: #fff; }

/* ERROR CONTAINER */
.page-content { flex: 1; display: flex; align-items: center; justify-content: center; padding: 40px 7%; }
.error-card { background: #fff; border: 1px solid #eeeeee; border-radius: 12px; padding: 50px 40px; text-align: center; max-width: 480px; width: 100%; box-shadow: 0 4px 20px rgba(0,0,0,0.03); }
.error-icon { font-size: 48px; color: #b80000; margin-bottom: 24px; } /* لون أحمر غامق للتحذير */
.error-title { font-size: 24px; letter-spacing: -0.5px; margin-bottom: 12px; font-weight: 700; }
.error-msg { font-size: 14px; color: #c0392b; line-height: 1.6; margin-bottom: 32px; background: #fdf0ef; padding: 14px; border: 1px solid #f5c6c2; border-radius: 6px; font-family: monospace; word-break: break-word; }

/* BUTTON */
.btn-back { display: inline-block; background: #171717; color: #fff; padding: 12px 24px; border-radius: 8px; font-size: 14px; font-weight: 600; transition: 0.2s; }
.btn-back:hover { background: #333; }

/* FOOTER */
.page-footer { padding: 28px 7%; background: #fff; border-top: 1px solid #eee; margin-top: auto; }
.page-footer span { font-size: 13px; color: #aaa; }
</style>
</head>
<body>

	<header class="navbar">
	    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">velo<span>ci</span></a>
	    <ul class="nav-links">
	        <li><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/products">Products</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
	        <li><a href="${pageContext.request.contextPath}/admin/customers">Customers</a></li>
	    </ul>
	    <span class="admin-badge">Admin</span>
	</header>

	<div class="page-content">
		<div class="error-card">
			<div class="error-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
			<h1 class="error-title">Data Issue Encountered</h1>
			<div class="error-msg">
				<c:choose>
					<c:when test="${not empty message}"><c:out value="${message}" /></c:when>
					<c:otherwise>An unexpected database error occurred while processing your request.</c:otherwise>
				</c:choose>
			</div>
			<a href="${pageContext.request.contextPath}/index.jsp" class="btn-back">Return to Homepage</a>
		</div>
	</div>

	<footer class="page-footer">
		<span>&#169; 2026 Veloci Admin Panel</span>
	</footer>

</body>
</html>