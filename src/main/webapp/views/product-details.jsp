<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${product.name} - Veloci</title>
    <style>*{box-sizing:border-box}body{margin:0;background:#f7f7f5;color:#171717;font:16px Arial,sans-serif}a{color:inherit;text-decoration:none}.navbar{height:72px;padding:0 7%;display:flex;align-items:center;justify-content:space-between;background:#fff;border-bottom:1px solid #eee}.logo{font-size:27px;font-weight:800;letter-spacing:-1px}.logo span{font-weight:400}.details-container{max-width:1100px;margin:45px auto;padding:0 24px;display:grid;grid-template-columns:1fr 1fr;gap:50px}.image-gallery img{width:100%;max-height:560px;object-fit:cover;border-radius:12px}.info{padding:24px}.info h1{font-size:38px;letter-spacing:-1px}.price{font-size:24px;font-weight:bold}.btn{padding:13px 20px;background:#171717;color:white;border:0;border-radius:7px;display:inline-block;margin-top:20px;cursor:pointer}select,input{padding:11px;border:1px solid #ccc;border-radius:6px}@media(max-width:700px){.details-container{grid-template-columns:1fr;margin:20px auto}.info{padding:0}}</style>
</head>
<body>
<header class="navbar"><a href="${pageContext.request.contextPath}/index.jsp" class="logo">velo<span>ci</span></a><nav><a href="${pageContext.request.contextPath}/index.jsp">Home</a> &nbsp; <a href="${pageContext.request.contextPath}/products">Shop</a></nav><a href="${pageContext.request.contextPath}/cart">Cart</a></header>
    <div style="max-width:1100px;margin:26px auto 0;padding:0 24px"><a href="${pageContext.request.contextPath}/products">&larr; Back to Products</a></div>
    
    <div class="details-container">
        <div class="image-gallery">
            <c:forEach var="img" items="${product.images}">
                <img src="${pageContext.request.contextPath}${img.imagePath}" alt="${product.name}">
            </c:forEach>
        </div>
        
        <div class="info">
            <h1>${product.name}</h1>
            <p><strong>Category:</strong> ${product.category.name}</p>
            <p class="price">$${product.price}</p>
            <p><strong>Available Stock:</strong> ${product.stock}</p>
            <p><strong>Description:</strong> ${product.description}</p>
            
            <!-- Dummy Add to Cart Form (We will build CartServlet next) -->
            <form action="${pageContext.request.contextPath}/cart" method="POST" style="margin-top: 20px;">
                <input type="hidden" name="productId" value="${product.id}">
                <label for="qty">Quantity:</label>
                <label for="size">Size:</label>
                <select id="size" name="size" required><option value="">Choose size</option><option>XS</option><option>S</option><option>M</option><option>L</option><option>XL</option><option>XXL</option></select>
                <label for="qty">Quantity:</label><input type="number" id="qty" name="quantity" value="1" min="1" max="${product.stock}" required>
                <button type="submit" class="btn">Add to Cart</button>
            </form>
        </div>
    </div>
</body>
</html>