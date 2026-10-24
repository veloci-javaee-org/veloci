<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <!-- إضافة FontAwesome للأيقونات -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Admin Dashboard | Veloci</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            background: #f7f7f5;
            color: #171717;
            font-family: Arial, Helvetica, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        /* NAVBAR */
        .navbar {
            height: 72px;
            padding: 0 7%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #fff;
            border-bottom: 1px solid #eee;
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
            margin: 0;
            padding: 0;
            align-items: center;
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

        /* MAIN CONTENT */
        main {
            max-width: 1100px;
            margin: 0 auto;
            padding: 60px 7%;
            width: 100%;
            flex: 1;
        }

        .page-header {
            margin-bottom: 40px;
        }

        .page-header h1 {
            margin: 0 0 8px;
            font-size: 34px;
            letter-spacing: -1px;
        }

        .page-header p {
            color: #666;
            font-size: 15px;
        }

        /* DASHBOARD GRID */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
        }

        .dash-card {
            background: #fff;
            border: 1px solid #eee;
            border-radius: 12px;
            padding: 50px 20px;
            text-align: center;
            transition: all 0.2s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .dash-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.04);
            border-color: #e0e0e0;
        }

        .dash-icon {
            font-size: 38px;
            color: #171717;
            margin-bottom: 18px;
            opacity: 0.9;
        }

        .dash-card h2 {
            font-size: 17px;
            font-weight: 700;
            margin: 0;
            letter-spacing: -0.3px;
        }

        /* TOOLBAR */
        .toolbar {
            display: flex;
            justify-content: flex-end;
            padding-top: 10px;
        }

        .btn-logout {
            padding: 10px 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: #fff;
            font-size: 14px;
            font-weight: 600;
            color: #171717;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-logout:hover {
            background: #f7f7f5;
            border-color: #ccc;
        }

        /* FOOTER */
        .page-footer {
            padding: 28px 7%;
            background: #fff;
            border-top: 1px solid #eee;
            text-align: center;
            margin-top: auto;
        }

        .page-footer span {
            font-size: 13px;
            color: #aaa;
        }

        @media (max-width: 768px) {
            .navbar { padding: 0 20px; }
            main { padding: 40px 20px; }
            .nav-links { display: none; }
        }
    </style>
</head>
<body>

    <header class="navbar">
        <a class="logo" href="${pageContext.request.contextPath}/index.jsp">velo<span>ci</span></a>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/admin" class="active">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Products</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/customers">Customers</a></li>
        </ul>
        <span class="admin-badge">Admin</span>
    </header>

    <main>
        <div class="page-header">
            <h1>Admin dashboard</h1>
            <p>Welcome, <c:out value="${sessionScope.name != null ? sessionScope.name : 'admin'}" />. Manage the store from here.</p>
        </div>

        <section class="dashboard-grid">
            <a class="dash-card" href="${pageContext.request.contextPath}/admin/products">
                <i class="fa-solid fa-box dash-icon"></i>
                <h2>Products</h2>
            </a>
            
            <a class="dash-card" href="${pageContext.request.contextPath}/admin/categories">
                <i class="fa-solid fa-sitemap dash-icon"></i>
                <h2>Categories</h2>
            </a>
            
            <a class="dash-card" href="${pageContext.request.contextPath}/admin/orders">
                <i class="fa-solid fa-clipboard-list dash-icon"></i>
                <h2>Orders</h2>
            </a>
            
            <a class="dash-card" href="${pageContext.request.contextPath}/admin/customers">
                <i class="fa-regular fa-user dash-icon"></i>
                <h2>Customers</h2>
            </a>
        </section>

        <div class="toolbar">
            <form action="${pageContext.request.contextPath}/logout" method="post">
                <button class="btn-logout" type="submit">Log out</button>
            </form>
        </div>
    </main>

    <footer class="page-footer">
        <span>&#169; 2026 Veloci Admin Panel</span>
    </footer>

</body>
</html>