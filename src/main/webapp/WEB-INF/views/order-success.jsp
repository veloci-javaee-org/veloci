<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width">
    <title>Order Placed | Veloci</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            background: #f7f7f5;
            color: #171717;
            font: 16px Arial;
        }
        .bar {
            padding: 22px 7%;
            background: white;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .bar .button {
            margin-top: 0;
        }
        .brand {
            font-size: 26px;
            font-weight: bold;
            text-decoration: none;
            color: inherit;
        }
        .wrap {
            max-width: 900px;
            margin: 45px auto;
            padding: 28px;
            background: #fff;
            border: 1px solid #eee;
            border-radius: 14px;
        }
        h1 {
            font-size: 36px;
            margin: 0 0 8px;
        }
        .sub {
            color: #888;
            margin: 0 0 25px;
        }
        h2 {
            font-size: 20px;
            margin: 28px 0 10px;
        }
        .item {
            display: flex;
            gap: 14px;
            align-items: center;
            padding: 17px 0;
            border-bottom: 1px solid #eee;
        }
        .thumb {
            width: 70px;
            height: 84px;
            flex: none;
            border-radius: 8px;
            background: #e9e8e3;
            overflow: hidden;
        }
        .thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        .info { flex: 1; }
        .price { font-weight: bold; }
        .line {
            display: flex;
            justify-content: space-between;
            margin: 8px 0;
        }
        .total {
            font-size: 21px;
            font-weight: bold;
            border-top: 1px solid #eee;
            padding-top: 14px;
            margin-top: 14px;
        }
        .delivery {
            background: #fafaf8;
            border: 1px solid #eee;
            border-radius: 10px;
            padding: 16px 18px;
            line-height: 1.6;
        }
        .button {
            display: inline-block;
            margin-top: 28px;
            padding: 12px 18px;
            background: #171717;
            border: 0;
            border-radius: 7px;
            color: #fff;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <header class="bar">
        <a class="brand" href="${pageContext.request.contextPath}/index.jsp">veloci</a>
    </header>

    <main class="wrap">
        <c:choose>

            <%-- Opened without placing an order --%>
            <c:when test="${empty sessionScope.lastOrderId}">
                <h1>No recent order</h1>
                <p class="sub">There is no order to show.</p>
                <a class="button" href="${pageContext.request.contextPath}/products">Browse clothing</a>
            </c:when>

            <c:otherwise>
                <h1>Thank you, ${sessionScope.name}!</h1>
                <p class="sub">Order #<c:out value="${sessionScope.lastOrderId}"/> has been placed.</p>

                <h2>Items</h2>
                <c:forEach var="item" items="${sessionScope.lastOrderItems}">
                    <div class="item">
                        <div class="thumb">
                            <c:if test="${not empty item.product.images}">
                                <img src="${pageContext.request.contextPath}${item.product.images[0].imagePath}"
                                     alt="${item.product.name}">
                            </c:if>
                        </div>
                        <div class="info">
                            <strong>${item.product.name}</strong><br>
                            Size ${item.size} · Qty ${item.quantity}
                        </div>
                        <span class="price">$<fmt:formatNumber value="${item.lineTotal}" pattern="#,##0.00"/></span>
                    </div>
                </c:forEach>

                <div class="line" style="margin-top:18px;">
                    <span>Subtotal</span>
                    <span>$<fmt:formatNumber value="${sessionScope.lastOrderSubtotal}" pattern="#,##0.00"/></span>
                </div>
                <div class="line">
                    <span>Shipping</span>
                    <span>$<fmt:formatNumber value="${sessionScope.lastOrderShipping}" pattern="#,##0.00"/></span>
                </div>
                <div class="line total">
                    <span>Total</span>
                    <span>$<fmt:formatNumber value="${sessionScope.lastOrderTotal}" pattern="#,##0.00"/></span>
                </div>

                <h2>Delivery</h2>
                <div class="delivery">
                    <strong>Name:</strong> ${sessionScope.name}<br>
                    <strong>Email:</strong> ${sessionScope.email}<br>
                    <strong>Phone:</strong> <c:out value="${sessionScope.lastOrderPhone}"/><br>
                    <strong>Address:</strong> <c:out value="${sessionScope.lastOrderAddress}"/><br>
                    <strong>Payment:</strong> Cash on Delivery
                </div>

                <a class="button" href="${pageContext.request.contextPath}/products">Continue shopping</a>
            </c:otherwise>

        </c:choose>
    </main>

</body>
</html>