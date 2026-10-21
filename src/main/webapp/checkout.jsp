<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width">
    <title>Checkout | Veloci</title>
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
        .layout {
            max-width: 1000px;
            margin: 45px auto;
            padding: 0 20px;
            display: flex;
            gap: 24px;
            align-items: flex-start;
        }
        .card {
            background: #fff;
            border: 1px solid #eee;
            border-radius: 14px;
            padding: 28px;
        }
        .form-card { flex: 3; }
        .summary-card { flex: 2; }
        h1 {
            font-size: 32px;
            margin: 0 0 6px;
        }
        h2 {
            font-size: 20px;
            margin: 26px 0 12px;
        }
        .summary-card h2 { margin-top: 0; }
        .field { margin-bottom: 14px; }
        label {
            display: block;
            color: #777;
            font-size: 13px;
            margin-bottom: 6px;
        }
        input[type="text"],
        input[type="email"],
        input[type="tel"],
        textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font: 16px Arial;
            color: #171717;
            background: #fff;
        }
        input[readonly] {
            background: #f3f3f0;
            color: #666;
        }
        textarea {
            min-height: 90px;
            resize: vertical;
        }
        input:focus,
        textarea:focus {
            outline: none;
            border-color: #171717;
        }
        .payment {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 14px 16px;
            border: 1px solid #171717;
            border-radius: 8px;
            background: #fafaf8;
        }
        .payment label {
            margin: 0;
            color: #171717;
            font-size: 16px;
        }
        .actions {
            display: flex;
            align-items: center;
            gap: 18px;
            margin-top: 26px;
        }
        .button {
            padding: 14px 24px;
            background: #171717;
            border: 0;
            border-radius: 7px;
            color: #fff;
            font: 600 15px Arial;
            cursor: pointer;
        }
        .button:hover { background: #333; }
        .back {
            color: #555;
            font-size: 14px;
        }
        .error {
            margin: 14px 0 0;
            padding: 12px 14px;
            background: #fee2e2;
            color: #991b1b;
            border-radius: 8px;
            font-size: 14px;
        }
        .item {
            display: flex;
            gap: 14px;
            align-items: center;
            padding: 14px 0;
            border-bottom: 1px solid #eee;
        }
        .thumb {
            width: 64px;
            height: 78px;
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
        .meta {
            color: #888;
            font-size: 14px;
        }
        .price { font-weight: bold; }
        .line {
            display: flex;
            justify-content: space-between;
            margin: 10px 0;
        }
        .total {
            font-size: 21px;
            font-weight: bold;
            border-top: 1px solid #eee;
            padding-top: 14px;
            margin-top: 14px;
        }
        @media (max-width: 800px) {
            .layout { flex-direction: column-reverse; }
            .form-card, .summary-card { width: 100%; flex: none; }
        }
    </style>
</head>
<body>

    <header class="bar">
        <a class="brand" href="${pageContext.request.contextPath}/index.jsp">veloci</a>
        <a href="${pageContext.request.contextPath}/cart">Back to cart</a>
    </header>

    <div class="layout">

        <!-- LEFT: customer info and delivery form -->
        <div class="card form-card">
            <h1>Checkout</h1>

            <c:if test="${param.error == 'order'}">
                <div class="error">We couldn't place your order. An item may be out of stock. Please check your cart and try again.</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/PlaceOrder" method="POST">

                <h2>Customer Information</h2>

                <div class="field">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" value="<c:out value='${sessionScope.name}'/>" readonly />
                </div>

                <div class="field">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" value="<c:out value='${sessionScope.email}'/>" readonly />
                </div>

                <h2>Delivery Details</h2>

                <div class="field">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" placeholder="e.g. 01012345678" required />
                </div>

                <div class="field">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" placeholder="Street, building, apartment, city" required></textarea>
                </div>

                <h2>Payment Method</h2>

                <div class="payment">
                    <input type="radio" id="cod" name="paymentMethod" value="COD" checked onclick="return false;">
                    <label for="cod">Cash on Delivery</label>
                </div>

                <div class="actions">
                    <button type="submit" class="button">Place Order</button>
                    <a class="back" href="${pageContext.request.contextPath}/cart">Back to cart</a>
                </div>

            </form>
        </div>

        <!-- RIGHT: order summary -->
        <div class="card summary-card">
            <h2>Order Summary</h2>

            <c:forEach var="item" items="${sessionScope.cartItems}">
                <div class="item">
                    <div class="thumb">
                        <c:if test="${not empty item.product.images}">
                            <img src="${pageContext.request.contextPath}${item.product.images[0].imagePath}"
                                 alt="<c:out value='${item.product.name}'/>">
                        </c:if>
                    </div>
                    <div class="info">
                        <strong><c:out value="${item.product.name}"/></strong><br>
                        <span class="meta">Size <c:out value="${item.size}"/> · Qty ${item.quantity}</span>
                    </div>
                    <span class="price">$<fmt:formatNumber value="${item.lineTotal}" pattern="#,##0.00"/></span>
                </div>
            </c:forEach>

            <div class="line" style="margin-top:18px;">
                <span>Subtotal</span>
                <span>$<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></span>
            </div>
            <div class="line">
                <span>Shipping</span>
                <span>$<fmt:formatNumber value="${shipping}" pattern="#,##0.00"/></span>
            </div>
            <div class="line total">
                <span>Total</span>
                <span>$<fmt:formatNumber value="${totalPrice}" pattern="#,##0.00"/></span>
            </div>
        </div>

    </div>

</body>
</html>