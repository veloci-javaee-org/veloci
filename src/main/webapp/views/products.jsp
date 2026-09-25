<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Products - Veloci</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .search-box {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .search-box input[type="text"] {
            padding: 10px;
            width: 300px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }
        .search-box button {
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .search-box button:hover {
            background-color: #2980b9;
        }
        .clear-link {
            margin-left: 15px;
            color: #e74c3c;
            text-decoration: none;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        .product-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.2s;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        .product-card h3 {
            margin: 10px 0;
            color: #2c3e50;
        }
        .product-card .category {
            color: #7f8c8d;
            font-size: 14px;
            margin: 5px 0;
        }
        .product-card .price {
            font-size: 24px;
            color: #27ae60;
            font-weight: bold;
            margin: 10px 0;
        }
        .product-card .stock {
            color: #e67e22;
            font-size: 14px;
        }
        .product-card .btn {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.2s;
        }
        .product-card .btn:hover {
            background-color: #2980b9;
        }
        .no-products {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Browse Products</h1>
        
        <!-- Search Form -->
        <div class="search-box">
            <form action="${pageContext.request.contextPath}/search" method="GET">
                <input type="text" name="keyword" placeholder="Search by product name..." 
                       value="${searchKeyword}" required>
                <button type="submit">Search</button>
                <c:if test="${not empty searchKeyword}">
                    <a href="${pageContext.request.contextPath}/products" class="clear-link">Clear Search</a>
                </c:if>
            </form>
        </div>

        <!-- Product Grid -->
        <div class="product-grid">
            <c:choose>
                <c:when test="${empty products}">
                    <div class="no-products">
                        <p>No products found.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="product" items="${products}">
                        <div class="product-card">
                            <c:choose>
                                <c:when test="${not empty product.images}">
                                    <img src="${pageContext.request.contextPath}${product.images[0].imagePath}" 
                                         alt="${product.name}">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/280x200?text=No+Image" 
                                         alt="No Image Available">
                                </c:otherwise>
                            </c:choose>
                            
                            <h3>${product.name}</h3>
                            <p class="category">Category: ${product.category.name}</p>
                            <p class="price">$${product.price}</p>
                            <p class="stock">Stock: ${product.stock} available</p>
                            <p>${product.description}</p>
                            
                            <a href="${pageContext.request.contextPath}/product-details?id=${product.id}" 
                               class="btn">View Details</a>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>