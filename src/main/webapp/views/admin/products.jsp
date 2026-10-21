<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products — Admin | Veloci</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <style>
        *{margin:0;padding:0;box-sizing:border-box}
        body{font-family:Arial,Helvetica,sans-serif;color:#171717;background:#f7f7f5;min-height:100vh}
        a{text-decoration:none;color:inherit}

        /* NAVBAR */
        .navbar{height:72px;padding:0 7%;display:flex;align-items:center;justify-content:space-between;background:#fff;border-bottom:1px solid #eee;position:sticky;top:0;z-index:10}
        .logo{font-size:27px;font-weight:800;letter-spacing:-1px}
        .logo span{font-weight:400}
        .nav-links{display:flex;gap:28px;list-style:none;font-size:14px;color:#555}
        .nav-links a:hover{color:#000}
        .nav-links .active{color:#171717;font-weight:700;border-bottom:2px solid #171717;padding-bottom:2px}
        .admin-badge{font-size:11px;font-weight:600;letter-spacing:1px;text-transform:uppercase;padding:5px 11px;border-radius:20px;background:#171717;color:#fff}

        /* PAGE */
        .page{padding:50px 7%}
        .page-header{display:flex;justify-content:space-between;align-items:flex-end;margin-bottom:32px}
        .page-header-left h1{font-size:34px;letter-spacing:-1px;margin-bottom:6px}
        .page-header-left p{color:#777;font-size:14px}

        /* TOOLBAR */
        .toolbar{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;gap:12px;flex-wrap:wrap}
        .search-form{display:flex;gap:8px}
        .search-form input{padding:10px 14px;border:1px solid #e0e0e0;border-radius:7px;font-size:14px;font-family:inherit;outline:none;width:240px}
        .search-form input:focus{border-color:#171717}

        /* BUTTONS */
        .btn{display:inline-block;padding:10px 18px;border-radius:7px;font-size:14px;font-weight:600;cursor:pointer;border:none;transition:.15s;text-decoration:none;font-family:inherit}
        .btn-dark{background:#171717;color:#fff}
        .btn-dark:hover{background:#333}
        .btn-ghost{background:#f7f7f5;color:#171717;border:1px solid #e0e0e0}
        .btn-ghost:hover{background:#efefeb}
        .btn-sm{padding:7px 13px;font-size:13px;border-radius:6px}
        .btn-edit{background:#f7f7f5;color:#171717;border:1px solid #e0e0e0}
        .btn-edit:hover{background:#efefeb}
        .btn-stock{background:#fff;color:#0d6efd;border:1px solid #b8d0f8}
        .btn-stock:hover{background:#f0f5ff}
        .btn-danger{background:#fff;color:#c0392b;border:1px solid #e0c0be}
        .btn-danger:hover{background:#fdf0ef;border-color:#c0392b}

        /* ALERTS */
        .alert{padding:13px 18px;border-radius:8px;font-size:14px;margin-bottom:20px}
        .alert-success{background:#f0faf3;color:#1a6b38;border:1px solid #c3e6cb}
        .alert-error{background:#fdf0ef;color:#922b21;border:1px solid #f5c6c2}

        /* STATS */
        .stats-row{display:flex;gap:16px;margin-bottom:24px}
        .stat-card{background:#fff;border:1px solid #eee;border-radius:12px;padding:20px 28px}
        .stat-label{font-size:12px;color:#999;text-transform:uppercase;letter-spacing:1px;margin-bottom:6px}
        .stat-value{font-size:30px;font-weight:800;letter-spacing:-1px}

        /* TABLE */
        .table-wrap{background:#fff;border:1px solid #eee;border-radius:12px;overflow-x:auto}
        .table-toolbar{padding:16px 22px;border-bottom:1px solid #eee;display:flex;align-items:center;justify-content:space-between}
        .table-toolbar span{font-size:13px;color:#999}
        table{width:100%;border-collapse:collapse}
        thead th{padding:13px 18px;text-align:left;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:#888;border-bottom:1px solid #eee;background:#fafafa}
        tbody td{padding:15px 18px;font-size:14px;border-bottom:1px solid #f3f3f3;vertical-align:middle}
        tbody tr:last-child td{border-bottom:none}
        tbody tr:hover td{background:#fafaf8}

        .img-thumb{width:48px;height:48px;object-fit:cover;border-radius:8px;border:1px solid #eee;display:block}
        .no-img{width:48px;height:48px;border-radius:8px;background:#f0f0ec;display:flex;align-items:center;justify-content:center;font-size:18px;color:#ccc}
        .prod-name{font-weight:700;font-size:15px}
        .badge{display:inline-block;padding:4px 11px;border-radius:20px;font-size:12px;font-weight:600}
        .badge-cat{background:#f0f0ec;color:#555}
        .badge-low{background:#fff3cd;color:#856404}
        .badge-ok{background:#f0faf3;color:#1a6b38}
        .price-cell{font-weight:700}
        .actions-cell{display:flex;gap:6px;align-items:center}

        /* EMPTY */
        .empty-state{padding:70px 20px;text-align:center}
        .empty-state .empty-icon{font-size:40px;opacity:.2;margin-bottom:16px}
        .empty-state h3{font-size:20px;margin-bottom:8px;letter-spacing:-.5px}
        .empty-state p{color:#888;font-size:14px;margin-bottom:22px}

        /* FOOTER */
        .page-footer{padding:28px 7%;background:#fff;border-top:1px solid #eee;margin-top:80px}
        .page-footer span{font-size:13px;color:#aaa}
    </style>
</head>
<body>

<header class="navbar">
    <a href="${pageContext.request.contextPath}/admin" class="logo">velo<span>ci</span></a>
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/admin/products" class="active">Products</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/categories">Categories</a></li>
    </ul>
    <span class="admin-badge">Admin</span>
</header>

<div class="page">

    <div class="page-header">
        <div class="page-header-left">
            <h1>Products</h1>
            <p>Manage your store's product catalogue.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/products?action=new" class="btn btn-dark">+ Add Product</a>
    </div>

    <c:if test="${not empty param.msg}">
        <div class="alert alert-success">&#10003;&nbsp;&nbsp;${param.msg}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-error">&#10005;&nbsp;&nbsp;${param.error}</div>
    </c:if>

    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-label">Total Products</div>
            <div class="stat-value">${products.size()}</div>
        </div>
    </div>

    <div class="toolbar">
        <form class="search-form" action="${pageContext.request.contextPath}/admin/products" method="get">
            <input type="text" name="keyword" placeholder="Search by name..."
                   value="<c:out value='${keyword}'/>">
            <button class="btn btn-dark" type="submit">Search</button>
            <c:if test="${not empty keyword}">
                <a class="btn btn-ghost" href="${pageContext.request.contextPath}/admin/products">Clear</a>
            </c:if>
        </form>
    </div>

    <div class="table-wrap table-responsive">
        <div class="table-toolbar">
            <span>${products.size()} products${not empty keyword ? ' matching "'.concat(keyword).concat('"') : ''}</span>
        </div>
        <table class="table align-middle mb-0">
            <thead>
                <tr>
                    <th>Image</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty products}">
                    <tr><td colspan="6">
                        <div class="empty-state">
                            <div class="empty-icon">&#9635;</div>
                            <h3>No products found</h3>
                            <p><c:choose><c:when test="${not empty keyword}">No products match your search.</c:when><c:otherwise>Start by adding your first product.</c:otherwise></c:choose></p>
                            <a href="${pageContext.request.contextPath}/admin/products?action=new" class="btn btn-dark">+ Add Product</a>
                        </div>
                    </td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty p.images}">
                                        <img class="img-thumb"
                                             src="${pageContext.request.contextPath}/${p.images[0].imagePath}"
                                             alt="${p.name}">
                                    </c:when>
                                    <c:otherwise><div class="no-img">&#128247;</div></c:otherwise>
                                </c:choose>
                            </td>
                            <td><span class="prod-name">${p.name}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty p.category.name}">
                                        <span class="badge badge-cat">${p.category.name}</span>
                                    </c:when>
                                    <c:otherwise><span style="color:#ccc">—</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="price-cell">$<fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.stock == 0}"><span class="badge badge-low">Out of stock</span></c:when>
                                    <c:when test="${p.stock <= 5}"><span class="badge badge-low">${p.stock} left</span></c:when>
                                    <c:otherwise><span class="badge badge-ok">${p.stock}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="actions-cell">
                                    <a class="btn btn-sm btn-edit"
                                       href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.id}">Edit</a>
                                    <a class="btn btn-sm btn-stock"
                                       href="${pageContext.request.contextPath}/admin/products?action=stock&id=${p.id}">Stock</a>
                                    <form action="${pageContext.request.contextPath}/admin/products" method="post"
                                          onsubmit="return confirm('Delete this product? This will also remove its images.');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${p.id}">
                                        <button class="btn btn-sm btn-danger" type="submit">Delete</button>
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

<footer class="page-footer"><span>&#169; 2026 Veloci Admin Panel</span></footer>
</body>
</html>
