<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width">
    <title>My Orders | Veloci</title>
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
        h1 {
            font-size: 36px;
            margin: 0 0 6px;
        }
        .sub {
            color: #888;
            margin: 0 0 22px;
        }
        .order-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            padding: 18px 16px;
            margin-bottom: 12px;
            border: 1px solid #eee;
            border-radius: 10px;
            background: #fafaf8;
            color: inherit;
            text-decoration: none;
        }
        .order-row:hover {
            border-color: #171717;
            background: #fff;
        }
        .order-main strong {
            font-size: 18px;
        }
        .order-meta {
            color: #888;
            font-size: 14px;
            margin-top: 6px;
            line-height: 1.5;
        }
        .order-side {
            text-align: right;
            flex: none;
        }
        .order-total {
            font-weight: bold;
            font-size: 18px;
        }
        .status {
            display: inline-block;
            margin-top: 6px;
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
        .empty {
            text-align: center;
            padding: 30px 0 10px;
        }
        .button {
            display: inline-block;
            margin-top: 12px;
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
        <a class="brand" href="${pageContext.request.contextPath}/home">veloci</a>
        <a href="${pageContext.request.contextPath}/profile">My profile</a>
    </header>

    <main class="wrap">
        <h1>My orders</h1>

        <c:choose>

            <%-- No orders yet --%>
            <c:when test="${empty orders}">
                <div class="empty">
                    <p class="sub">You haven't placed any orders yet.</p>
                    <a class="button" href="${pageContext.request.contextPath}/products">Browse clothing</a>
                </div>
            </c:when>

            <%-- One clickable row per order --%>
            <c:otherwise>
                <p class="sub">Click an order to see its details.</p>

                <c:forEach var="o" items="${orders}">
                    <a class="order-row" href="${pageContext.request.contextPath}/order-details?id=${o.id}">
                        <div class="order-main">
                            <strong>Order #${o.id}</strong>
                            <div class="order-meta">
                                <fmt:formatDate value="${o.orderDate}" pattern="dd MMM yyyy, HH:mm"/><br>
                                <c:out value="${o.shippingAddress}"/>
                            </div>
                        </div>
                        <div class="order-side">
                            <div class="order-total">$<fmt:formatNumber value="${o.totalAmount}" pattern="#,##0.00"/></div>
                            <span class="status ${fn:toLowerCase(o.status)}"><c:out value="${o.status}"/></span>
                        </div>
                    </a>
                </c:forEach>
            </c:otherwise>

        </c:choose>
    </main>

</body>
</html>