<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <title>Update Stock — Admin | Veloci</title>
    <style>
        *{margin:0;padding:0;box-sizing:border-box}
        body{font-family:Arial,Helvetica,sans-serif;color:#171717;background:#f7f7f5;min-height:100vh}
        a{text-decoration:none;color:inherit}
        .navbar{height:72px;padding:0 7%;display:flex;align-items:center;justify-content:space-between;background:#fff;border-bottom:1px solid #eee;position:sticky;top:0;z-index:10}
        .logo{font-size:27px;font-weight:800;letter-spacing:-1px}
        .logo span{font-weight:400}
        .nav-links{display:flex;gap:28px;list-style:none;font-size:14px;color:#555}
        .nav-links a:hover{color:#000}
        .nav-links .active{color:#171717;font-weight:700;border-bottom:2px solid #171717;padding-bottom:2px}
        .admin-badge{font-size:11px;font-weight:600;letter-spacing:1px;text-transform:uppercase;padding:5px 11px;border-radius:20px;background:#171717;color:#fff}
        .page{padding:50px 7%}
        .breadcrumb{display:flex;align-items:center;gap:8px;font-size:13px;color:#aaa;margin-bottom:28px}
        .breadcrumb a{color:#555}
        .breadcrumb a:hover{color:#171717;border-bottom:1px solid #171717}
        .breadcrumb .sep{color:#ddd}
        .breadcrumb .current{color:#171717;font-weight:600}
        .alert{padding:13px 18px;border-radius:8px;font-size:14px;margin-bottom:22px}
        .alert-error{background:#fdf0ef;color:#922b21;border:1px solid #f5c6c2}
        .wrap{display:grid;grid-template-columns:420px 1fr;gap:24px;align-items:start}
        .card{background:#fff;border:1px solid #eee;border-radius:12px;padding:32px 36px}
        .card-title{font-size:18px;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
        .card-sub{font-size:13px;color:#999;margin-bottom:28px}
        .field{margin-bottom:20px}
        .field label{display:block;font-size:13px;font-weight:700;color:#444;margin-bottom:7px}
        .field .hint{font-size:12px;color:#aaa;margin-top:5px}
        input[type=number]{width:100%;padding:11px 14px;border:1px solid #e0e0e0;border-radius:7px;font-size:14px;font-family:inherit;color:#171717;outline:none;transition:border-color .15s,box-shadow .15s}
        input[type=number]:focus{border-color:#171717;box-shadow:0 0 0 3px rgba(23,23,23,.07)}
        .btn{display:inline-block;padding:12px 22px;border-radius:7px;font-size:14px;font-weight:600;cursor:pointer;border:none;transition:.15s;text-decoration:none;font-family:inherit}
        .btn-dark{background:#171717;color:#fff}
        .btn-dark:hover{background:#333}
        .btn-outline{background:#fff;color:#555;border:1px solid #d0d0d0}
        .btn-outline:hover{border-color:#171717;color:#171717}
        .btn-row{display:flex;gap:10px;margin-top:26px}

        /* current stock display */
        .stock-display{background:#f7f7f5;border:1px solid #ebebeb;border-radius:12px;padding:28px 32px;text-align:center}
        .stock-display .lbl{font-size:12px;color:#aaa;text-transform:uppercase;letter-spacing:1px;margin-bottom:10px}
        .stock-display .val{font-size:52px;font-weight:800;letter-spacing:-2px}
        .stock-display .unit{font-size:14px;color:#aaa;margin-top:6px}
        .stock-low{color:#856404}
        .stock-ok{color:#1a6b38}
        .stock-zero{color:#c0392b}

        .prod-name{font-size:20px;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
        .prod-cat{font-size:13px;color:#aaa}

        .page-footer{padding:28px 7%;background:#fff;border-top:1px solid #eee;margin-top:80px}
        .page-footer span{font-size:13px;color:#aaa}
        @media(max-width:900px){.wrap{grid-template-columns:1fr}}
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

    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/products">Products</a>
        <span class="sep">&#8250;</span>
        <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${product.id}">${product.name}</a>
        <span class="sep">&#8250;</span>
        <span class="current">Update Stock</span>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error">&#10005;&nbsp;&nbsp;${error}</div>
    </c:if>

    <div class="wrap">

        <div class="card">
            <div class="prod-name">${product.name}</div>
            <div class="prod-cat">${not empty product.category.name ? product.category.name : 'No category'}</div>

            <div class="card-title" style="margin-top:28px">Update Stock</div>
            <div class="card-sub">Set the new stock quantity for this product.</div>

            <form action="${pageContext.request.contextPath}/admin/products?action=updateStock"
                  method="post">
                <input type="hidden" name="id" value="${product.id}">

                <div class="field">
                    <label>New Stock Quantity</label>
                    <input type="number" name="stock" min="0" required
                           value="${product.stock}" placeholder="0">
                    <div class="hint">Enter 0 to mark the product as out of stock.</div>
                </div>

                <div class="btn-row">
                    <button class="btn btn-dark" type="submit">Save Stock</button>
                    <a class="btn btn-outline"
                       href="${pageContext.request.contextPath}/admin/products">Cancel</a>
                </div>
            </form>
        </div>

        <!-- Current stock indicator -->
        <div class="stock-display">
            <div class="lbl">Current Stock</div>
            <div class="val
                <c:choose>
                    <c:when test="${product.stock == 0}"> stock-zero</c:when>
                    <c:when test="${product.stock <= 5}"> stock-low</c:when>
                    <c:otherwise> stock-ok</c:otherwise>
                </c:choose>">
                ${product.stock}
            </div>
            <div class="unit">units available</div>
        </div>

    </div>
</div>

<footer class="page-footer"><span>&#169; 2026 Veloci Admin Panel</span></footer>
</body>
</html>
