<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <title>Your Cart | Veloci</title>
    <style>
        body { background: #f7f7f5; color: #171717; }
        .brand { color: inherit; font-size: 1.6rem; font-weight: 800; text-decoration: none; }
        .cart-panel { border: 1px solid #eee; border-radius: 14px; }
        .product-image { width: 76px; height: 92px; object-fit: cover; border-radius: 8px; }
    </style>
</head>
<body>
    <header class="bg-white border-bottom">
        <nav class="container py-3 d-flex justify-content-between align-items-center" aria-label="Main navigation">
            <a class="brand" href="${pageContext.request.contextPath}/home">velo<span class="fw-normal">ci</span></a>
            <a href="${pageContext.request.contextPath}/products">Continue shopping</a>
        </nav>
    </header>
    <main class="container py-5">
        <section class="cart-panel bg-white p-3 p-md-4 mx-auto" style="max-width: 900px">
            <h1 class="h2 mb-4">Your cart</h1>
            <c:choose>
                <c:when test="${empty cartItems}">
                    <p>Your cart is empty.</p>
                    <a class="btn btn-dark" href="${pageContext.request.contextPath}/products">Browse products</a>
                </c:when>
                <c:otherwise>
                    <ul class="list-group list-group-flush">
                        <c:forEach var="item" items="${cartItems}">
                            <li class="list-group-item px-0 py-3 d-flex justify-content-between align-items-center gap-3">
                                <div class="d-flex align-items-center gap-3">
                                    <c:if test="${not empty item.product.images}">
                                        <img class="product-image" src="${pageContext.request.contextPath}/${item.product.images[0].imagePath}" alt="<c:out value='${item.product.name}'/>">
                                    </c:if>
                                    <span><strong><c:out value="${item.product.name}"/></strong><br>Quantity: ${item.quantity}</span>
                                </div>
                                <strong class="text-nowrap">$<fmt:formatNumber value="${item.lineTotal}" pattern="#,##0.00"/></strong>
                            </li>
                        </c:forEach>
                    </ul>
                    <p class="text-end fs-5 fw-bold mt-4">Total: $<fmt:formatNumber value="${cartTotal}" pattern="#,##0.00"/></p>
                    <form method="post" action="${pageContext.request.contextPath}/PlaceOrder" class="text-end">
                        <button class="btn btn-dark" type="submit">Place order</button>
                    </form>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</body>
</html>
