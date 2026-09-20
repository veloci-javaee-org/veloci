<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${product.name} - Veloci</title>
    <style>
        .details-container { display: flex; gap: 40px; padding: 40px; }
        .image-gallery img { max-width: 400px; border: 1px solid #ddd; margin-bottom: 10px; }
        .info h1 { margin-top: 0; }
        .price { font-size: 24px; color: #2ecc71; font-weight: bold; }
        .btn { padding: 10px 20px; background-color: #3498db; color: white; text-decoration: none; border-radius: 5px; display: inline-block; margin-top: 20px;}
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/products">&larr; Back to Products</a>
    
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
                <input type="number" id="qty" name="quantity" value="1" min="1" max="${product.stock}" required>
                <button type="submit" class="btn">Add to Cart</button>
            </form>
        </div>
    </div>
</body>
</html>