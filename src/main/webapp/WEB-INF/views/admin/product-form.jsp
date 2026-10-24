<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <title><c:choose><c:when test="${not empty product && product.id != 0}">Edit Product</c:when><c:otherwise>Add Product</c:otherwise></c:choose> — Admin | Veloci</title>
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
        .alert-success{background:#f0faf3;color:#1a6b38;border:1px solid #c3e6cb}

        .form-layout{display:grid;grid-template-columns:1fr 320px;gap:24px;align-items:start}
        .card{background:#fff;border:1px solid #eee;border-radius:12px;padding:32px 36px}
        .card-title{font-size:18px;font-weight:800;letter-spacing:-.5px;margin-bottom:4px}
        .card-sub{font-size:13px;color:#999;margin-bottom:28px}
        .section-title{font-size:13px;font-weight:700;color:#888;text-transform:uppercase;letter-spacing:.8px;margin:28px 0 14px;padding-top:20px;border-top:1px solid #f0f0f0}

        .field{margin-bottom:18px}
        .field label{display:block;font-size:13px;font-weight:700;color:#444;margin-bottom:7px}
        .field .hint{font-size:12px;color:#aaa;margin-top:5px}
        .required{color:#c0392b;margin-left:2px}
        input[type=text],input[type=number],select,textarea{width:100%;padding:11px 14px;border:1px solid #e0e0e0;border-radius:7px;font-size:14px;font-family:inherit;color:#171717;background:#fff;outline:none;transition:border-color .15s,box-shadow .15s}
        input:focus,select:focus,textarea:focus{border-color:#171717;box-shadow:0 0 0 3px rgba(23,23,23,.07)}
        textarea{height:110px;resize:vertical}
        .row-2{display:grid;grid-template-columns:1fr 1fr;gap:16px}

        .btn{display:inline-block;padding:12px 22px;border-radius:7px;font-size:14px;font-weight:600;cursor:pointer;border:none;transition:.15s;text-decoration:none;font-family:inherit}
        .btn-dark{background:#171717;color:#fff}
        .btn-dark:hover{background:#333}
        .btn-outline{background:#fff;color:#555;border:1px solid #d0d0d0}
        .btn-outline:hover{border-color:#171717;color:#171717}
        .btn-row{display:flex;gap:10px;margin-top:26px}
        .btn-sm{padding:7px 12px;font-size:13px;border-radius:6px}
        .btn-danger-sm{background:#fff;color:#c0392b;border:1px solid #e0c0be;padding:6px 10px;font-size:12px;border-radius:5px;cursor:pointer;font-family:inherit}
        .btn-danger-sm:hover{background:#fdf0ef}

        /* Image grid */
        .img-grid{display:flex;flex-wrap:wrap;gap:12px;margin-bottom:16px}
        .img-item{position:relative}
        .img-item img{width:90px;height:90px;object-fit:cover;border-radius:8px;border:1px solid #eee;display:block}
        .del-img-btn{position:absolute;top:-6px;right:-6px;width:22px;height:22px;border-radius:50%;background:#c0392b;color:#fff;border:none;font-size:13px;cursor:pointer;display:flex;align-items:center;justify-content:center;line-height:1}
        .del-img-btn:hover{background:#a93226}
        .upload-area{border:2px dashed #e0e0e0;border-radius:8px;padding:20px;text-align:center;background:#fafafa}
        .upload-area input{display:none}
        .upload-area label{cursor:pointer;font-size:14px;color:#555}
        .upload-area .upload-hint{font-size:12px;color:#aaa;margin-top:6px}
        .upload-trigger{display:inline-block;padding:9px 18px;border-radius:7px;font-size:14px;font-weight:600;background:#171717;color:#fff;cursor:pointer;margin-bottom:8px}

        /* Sidebar */
        .info-card{background:#fff;border:1px solid #eee;border-radius:12px;padding:24px 28px;margin-bottom:16px}
        .info-card h4{font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:#aaa;margin-bottom:14px}
        .info-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid #f5f5f5;font-size:13px}
        .info-row:last-child{border-bottom:none}
        .info-row .lbl{color:#999}
        .info-row .val{font-weight:600}
        .tip-card{background:#f7f7f5;border:1px solid #ebebeb;border-radius:12px;padding:20px 24px}
        .tip-card h4{font-size:12px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:#aaa;margin-bottom:10px}
        .tip-card li{font-size:13px;color:#666;margin-bottom:7px;line-height:1.5;margin-left:14px}

        .page-footer{padding:28px 7%;background:#fff;border-top:1px solid #eee;margin-top:80px}
        .page-footer span{font-size:13px;color:#aaa}

        @media(max-width:900px){.form-layout{grid-template-columns:1fr}.row-2{grid-template-columns:1fr}}
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
        <span class="current">
            <c:choose>
                <c:when test="${not empty product && product.id != 0}">Edit — ${product.name}</c:when>
                <c:otherwise>Add New</c:otherwise>
            </c:choose>
        </span>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error">&#10005;&nbsp;&nbsp;${error}</div>
    </c:if>
    <c:if test="${not empty param.msg}">
        <div class="alert alert-success">&#10003;&nbsp;&nbsp;${param.msg}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-error">&#10005;&nbsp;&nbsp;<c:out value="${param.error}"/></div>
    </c:if>

    <div class="form-layout">

        <!-- LEFT -->
        <div>
            <!-- Main product form -->
            <div class="card">
                <div class="card-title">
                    <c:choose>
                        <c:when test="${not empty product && product.id != 0}">Edit Product</c:when>
                        <c:otherwise>New Product</c:otherwise>
                    </c:choose>
                </div>
                <div class="card-sub">
                    <c:choose>
                        <c:when test="${not empty product && product.id != 0}">Update product details below.</c:when>
                        <c:otherwise>Fill in the details to add a new product to your store.</c:otherwise>
                    </c:choose>
                </div>

                <form action="${pageContext.request.contextPath}/admin/products"
                      method="post"
                      enctype="multipart/form-data">

                    <input type="hidden" name="id" value="${not empty product ? product.id : 0}">

                    <div class="field">
                        <label>Product Name <span class="required">*</span></label>
                        <input type="text" name="name" maxlength="150" required
                               placeholder="e.g. Classic White T-Shirt"
                               value="<c:out value='${product.name}'/>">
                    </div>

                    <div class="field">
                        <label>Description</label>
                        <textarea name="description" placeholder="Describe the product..."><c:out value="${product.description}"/></textarea>
                    </div>

                    <div class="row-2">
                        <div class="field">
                            <label>Price (USD) <span class="required">*</span></label>
                            <input type="number" name="price" step="0.01" min="0.01" required
                                   placeholder="0.00"
                                   value="${not empty product && product.price > 0 ? product.price : ''}">
                        </div>
                        <div class="field">
                            <label>Stock <span class="required">*</span></label>
                            <input type="number" name="stock" min="0" required
                                   placeholder="0"
                                   value="${not empty product ? product.stock : ''}">
                        </div>
                    </div>

                    <div class="field">
                        <label>Category</label>
                        <select name="categoryId">
                            <option value="">— No Category —</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}"
                                    <c:if test="${not empty product && not empty product.category && product.category.id == cat.id}">selected</c:if>>
                                    ${cat.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="section-title">Product Images</div>
                    <div class="upload-area">
                        <label for="imgInput" class="upload-trigger">Choose Images</label>
                        <input type="file" id="imgInput" name="images" accept="image/jpeg,image/png,image/webp,image/gif"
                               multiple onchange="showFileNames(this)">
                        <div class="upload-hint">JPG, PNG, WEBP or GIF — max 5 MB each. Existing images are kept.</div>
                        <div id="fileNames" style="font-size:13px;color:#555;margin-top:8px;"></div>
                    </div>

                    <div class="btn-row">
                        <button class="btn btn-dark" type="submit">
                            <c:choose>
                                <c:when test="${not empty product && product.id != 0}">Save Changes</c:when>
                                <c:otherwise>Add Product</c:otherwise>
                            </c:choose>
                        </button>
                        <a class="btn btn-outline" href="${pageContext.request.contextPath}/admin/products">Cancel</a>
                    </div>

                </form>
            </div>

            <!-- Image management (edit mode only) -->
            <c:if test="${not empty product && product.id != 0}">
                <div class="card" style="margin-top:20px">
                    <div class="card-title">Images</div>
                    <div class="card-sub">Add or remove product images.</div>

                    <!-- Current images -->
                    <c:if test="${not empty product.images}">
                        <div class="img-grid">
                            <c:forEach var="img" items="${product.images}">
                                <div class="img-item">
                                    <img src="${pageContext.request.contextPath}/${img.imagePath}" alt="product image">
                                    <form action="${pageContext.request.contextPath}/admin/products?action=deleteImage"
                                          method="post" style="display:inline"
                                          onsubmit="return confirm('Remove this image?');">
                                        <input type="hidden" name="imageId"   value="${img.id}">
                                        <input type="hidden" name="productId" value="${product.id}">
                                        <button class="del-img-btn" type="submit" title="Delete">&#10005;</button>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                    <c:if test="${empty product.images}">
                        <p style="font-size:13px;color:#aaa;margin-bottom:16px">No images yet.</p>
                    </c:if>

                </div>
            </c:if>
        </div>

        <!-- RIGHT: Sidebar -->
        <div>
            <c:if test="${not empty product && product.id != 0}">
                <div class="info-card">
                    <h4>Product Info</h4>
                    <div class="info-row"><span class="lbl">ID</span><span class="val">#${product.id}</span></div>
                    <div class="info-row"><span class="lbl">Stock</span><span class="val">${product.stock} units</span></div>
                    <div class="info-row"><span class="lbl">Images</span><span class="val">${product.images.size()}</span></div>
                </div>
            </c:if>
            <div class="tip-card">
                <h4>Tips</h4>
                <ul>
                    <li>Use a clear, descriptive product name.</li>
                    <li>Price must be greater than 0.</li>
                    <li>Stock can be updated separately via the Stock button on the list.</li>
                    <li>Images are uploaded per product — you can add more after creating.</li>
                    <li>Deleting a product removes all its images permanently.</li>
                </ul>
            </div>
        </div>

    </div>
</div>

<footer class="page-footer"><span>&#169; 2026 Veloci Admin Panel</span></footer>

<script>
    function showFileNames(input) {
        var names = Array.from(input.files).map(f => f.name).join(', ');
        document.getElementById('fileNames').textContent = names || '';
    }
</script>
</body>
</html>
