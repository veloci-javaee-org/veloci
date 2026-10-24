<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <title>Categories — Admin | Veloci</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, Helvetica, sans-serif; color: #171717; background: #f7f7f5; min-height: 100vh; }
        a { text-decoration: none; color: inherit; }

        /* NAVBAR */
        .navbar { height: 72px; padding: 0 7%; display: flex; align-items: center; justify-content: space-between; background: #ffffff; border-bottom: 1px solid #eeeeee; position: sticky; top: 0; z-index: 10; }
        .logo { font-size: 27px; font-weight: 800; letter-spacing: -1px; }
        .logo span { font-weight: 400; }
        .nav-links { display: flex; gap: 28px; list-style: none; font-size: 14px; color: #555; margin: 0; padding: 0; }
        .nav-links a:hover { color: #000; }
        .nav-links .active { color: #171717; font-weight: 700; border-bottom: 2px solid #171717; padding-bottom: 2px; }
        .admin-badge { font-size: 11px; font-weight: 600; letter-spacing: 1px; text-transform: uppercase; padding: 5px 11px; border-radius: 20px; background: #171717; color: #fff; }

        /* PAGE */
        .page { padding: 50px 7%; }
        .page-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 32px; }
        .page-header-left h1 { font-size: 34px; letter-spacing: -1px; margin-bottom: 6px; }
        .page-header-left p { color: #777; font-size: 14px; margin: 0; }

        /* BUTTONS */
        .btn { display: inline-block; padding: 11px 20px; border-radius: 7px; font-size: 14px; font-weight: 600; cursor: pointer; border: none; transition: .15s; text-decoration: none; }
        .btn-dark { background: #171717; color: #fff; }
        .btn-dark:hover { background: #333; }
        .btn-edit { background: #f7f7f5; color: #171717; border: 1px solid #e0e0e0; padding: 7px 14px; font-size: 13px; border-radius: 6px; }
        .btn-edit:hover { background: #efefeb; }
        .btn-danger { background: #fff; color: #c0392b; border: 1px solid #e0c0be; padding: 7px 14px; font-size: 13px; border-radius: 6px; cursor: pointer; }
        .btn-danger:hover { background: #fdf0ef; border-color: #c0392b; }

        /* ALERTS */
        .alert { padding: 13px 18px; border-radius: 8px; font-size: 14px; margin-bottom: 24px; }
        .alert-success { background: #f0faf3; color: #1a6b38; border: 1px solid #c3e6cb; }
        .alert-error { background: #fdf0ef; color: #922b21; border: 1px solid #f5c6c2; }

        /* STATS */
        .stats-row { display: flex; gap: 16px; margin-bottom: 28px; }
        .stat-card { background: #fff; border: 1px solid #eeeeee; border-radius: 12px; padding: 20px 28px; }
        .stat-label { font-size: 12px; color: #999; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 6px; }
        .stat-value { font-size: 30px; font-weight: 800; letter-spacing: -1px; }

        /* TABLE */
        .table-wrap { background: #fff; border: 1px solid #eeeeee; border-radius: 12px; overflow: hidden; }
        .table-toolbar { padding: 16px 22px; border-bottom: 1px solid #eeeeee; display: flex; align-items: center; justify-content: space-between; }
        .table-toolbar span { font-size: 13px; color: #999; }
        table { width: 100%; border-collapse: collapse; }
        thead th { padding: 13px 20px; text-align: left; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .8px; color: #888; border-bottom: 1px solid #eeeeee; background: #fafafa; }
        tbody td { padding: 16px 20px; font-size: 14px; border-bottom: 1px solid #f3f3f3; vertical-align: middle; }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover td { background: #fafaf8; }
        .cell-num { font-size: 12px; color: #ccc; font-weight: 600; width: 48px; }
        .cat-name { font-weight: 700; font-size: 15px; }
        .desc-cell { color: #777; font-size: 13px; max-width: 300px; }
        .badge { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge-dark { background: #171717; color: #fff; }
        .badge-light { background: #f0f0ec; color: #999; }
        .actions-cell { display: flex; gap: 8px; align-items: center; }

        /* EMPTY */
        .empty-state { padding: 70px 20px; text-align: center; }
        .empty-state .empty-icon { font-size: 42px; margin-bottom: 16px; opacity: .2; }
        .empty-state h3 { font-size: 20px; margin-bottom: 8px; letter-spacing: -.5px; }
        .empty-state p { color: #888; font-size: 14px; margin-bottom: 22px; }

        /* FOOTER */
        .page-footer { padding: 28px 7%; background: #fff; border-top: 1px solid #eee; margin-top: 80px; }
        .page-footer span { font-size: 13px; color: #aaa; }
    </style>
</head>

<body>

    <!-- NAVBAR -->
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/home" class="logo">velo<span>ci</span></a>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/products">Products</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories" class="active">Categories</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/orders">Orders</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/customers">Customers</a></li>
        </ul>
        <span class="admin-badge">Admin</span>
    </header>

    <!-- PAGE -->
    <div class="page">

        <div class="page-header">
            <div class="page-header-left">
                <h1>Categories</h1>
                <p>Manage your product categories.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/categories?action=new" class="btn btn-dark">+ Add Category</a>
        </div>

        <c:if test="${not empty param.msg}">
            <div class="alert alert-success">
                &#10003;&nbsp;&nbsp;
                <c:out value="${param.msg}" />
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                &#10005;&nbsp;&nbsp;
                <c:out value="${error}" />
            </div>
        </c:if>

        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-label">Total Categories</div>
                <div class="stat-value">${categories.size()}</div>
            </div>
        </div>

        <div class="table-wrap table-responsive">
            <div class="table-toolbar">
                <span>${categories.size()} categories</span>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Products</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty categories}">
                            <tr>
                                <td colspan="5">
                                    <div class="empty-state">
                                        <div class="empty-icon">&#9641;</div>
                                        <h3>No categories yet</h3>
                                        <p>Create your first category to start organizing products.</p>
                                        <a href="${pageContext.request.contextPath}/admin/categories?action=new" class="btn btn-dark">+ Add Category</a>
                                    </div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="cat" items="${categories}" varStatus="loop">
                                <tr>
                                    <td class="cell-num">${loop.count}</td>
                                    <td><span class="cat-name"><c:out value="${cat.name}" /></span></td>
                                    <td class="desc-cell">
                                        <c:choose>
                                            <c:when test="${not empty cat.description}">
                                                <c:out value="${cat.description}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #ddd;">—</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:set var="count" value="${productCounts[cat.id]}" />
                                        <c:choose>
                                            <c:when test="${count > 0}">
                                                <span class="badge badge-dark">${count}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-light">0</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions-cell">
                                            <a class="btn-edit" href="${pageContext.request.contextPath}/admin/categories?action=edit&id=${cat.id}">Edit</a>
                                            <form action="${pageContext.request.contextPath}/admin/categories" method="post" onsubmit="return confirm('Delete this category? ${productCounts[cat.id]} product(s) will become uncategorized.');">
                                                <input type="hidden" name="action" value="delete"> 
                                                <input type="hidden" name="id" value="${cat.id}">
                                                <button class="btn-danger" type="submit">Delete</button>
                                            </form>
                                        </div>
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