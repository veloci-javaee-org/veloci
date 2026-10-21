<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width">
    <title>Order #${order.id} | Veloci</title>
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
            background: #fff;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
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
        .back {
            color: #555;
            text-decoration: none;
            font-size: 14px;
        }
        h1 {
            font-size: 36px;
            margin: 14px 0 6px;
        }
        .sub {
            color: #888;
            margin: 0 0 8px;
        }
        h2 {
            font-size: 20px;
            margin: 28px 0 10px;
        }
        .status {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            background: #eee;
            color: #555;
            font-size: 12px;
            font-weight: bold;
        }
        .status.pending { background: #fff3cd; color: #8a6d00; }
        .status.shipped { background: #dbeafe; color: #1e40af; }
        .status.delivered { background: #dcfce7; color: #166534; }
        .status.cancelled { background: #fee2e2; color: #991b1b; }
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
        .meta { color: #888; font-size: 14px; }
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
    </style>
</head>
<body>

    <header class="bar">
        <a class="brand" href="${pageContext.request.contextPath}/index.jsp">veloci</a>
        <a href="${pageContext.request.contextPath}/orders">My orders</a>
    </header>

    <main class="wrap">
        <a class="back" href="${pageContext.request.contextPath}/orders">&larr; Back to my orders</a>

        <h1>Order #${order.id}</h1>
        <p class="sub">
            Placed on <c:out value="${order.orderDateFormatted}"/>
            <c:if test="${not empty order.status}">
                &nbsp;<span class="status ${fn:toLowerCase(order.status)}"><c:out value="${order.status}"/></span>
            </c:if>
        </p>

        <h2>Items</h2>
        <c:forEach var="item" items="${order.orderItems}">
            <div class="item">
                <div class="thumb">
                    <c:if test="${not empty item.product.images}">
                        <img src="${pageContext.request.contextPath}${item.product.images[0].imagePath}"
                             alt="<c:out value='${item.product.name}'/>">
                    </c:if>
                </div>
                <div class="info">
                    <strong><c:out value="${item.product.name}"/></strong><br>
                    <span class="meta">
                        Size <c:out value="${item.size}"/> · Qty ${item.quantity}
                        · $<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/> each
                    </span>
                </div>
                <span class="price">$<fmt:formatNumber value="${item.lineTotal}" pattern="#,##0.00"/></span>
            </div>
        </c:forEach>

        <div class="line" style="margin-top:18px;">
            <span>Subtotal</span>
            <span>$<fmt:formatNumber value="${order.subtotal}" pattern="#,##0.00"/></span>
        </div>
        <div class="line">
            <span>Shipping</span>
            <span>$<fmt:formatNumber value="${order.shipping}" pattern="#,##0.00"/></span>
        </div>
        <div class="line total">
            <span>Total</span>
            <span>$<fmt:formatNumber value="${order.totalPrice}" pattern="#,##0.00"/></span>
        </div>

        <h2>Delivery</h2>
        <div class="delivery">
            <strong>Name:</strong> <c:out value="${sessionScope.name}"/><br>
            <strong>Email:</strong> <c:out value="${sessionScope.email}"/><br>
            <strong>Phone:</strong> <c:out value="${order.shippingPhone}"/><br>
            <strong>Address:</strong> <c:out value="${order.shippingAddress}"/><br>
            <strong>Payment:</strong> Cash on Delivery
        </div>
    </main>

</body>
</html>