<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width">
    <title>My Profile | Veloci</title>
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
        .brand {
            font-size: 26px;
            font-weight: bold;
            text-decoration: none;
            color: inherit;
        }
        .wrap {
            max-width: 760px;
            margin: 50px auto;
            padding: 32px;
            background: white;
            border-radius: 14px;
        }
        .wrap h1 {
            font-size: 36px;
            margin: 0 0 24px;
        }
        .row {
            padding: 16px 0;
            border-bottom: 1px solid #eee;
        }
        .label {
            display: block;
            color: #777;
            font-size: 13px;
            margin-bottom: 5px;
        }
        .button {
            display: inline-block;
            margin-top: 24px;
            padding: 12px 18px;
            background: #171717;
            border-radius: 7px;
            color: white;
            text-decoration: none;
        }
    </style>
</head>
<body>

    <header class="bar">
        <a class="brand" href="${pageContext.request.contextPath}/index.jsp">veloci</a>
        <a href="${pageContext.request.contextPath}/products">Shop</a>
    </header>

    <main class="wrap">
        <h1>My profile</h1>

        <div class="row">
            <span class="label">Name</span>
            <c:out value="${profileName}"/>
        </div>
        <div class="row">
            <span class="label">Username</span>
            <c:out value="${sessionScope.username}"/>
        </div>
        <div class="row">
            <span class="label">Email</span>
            <c:out value="${profileEmail}"/>
        </div>
        <div class="row">
            <span class="label">Phone</span>
            <c:out value="${profilePhone}"/>
        </div>
        <div class="row">
            <span class="label">Address</span>
            <c:out value="${profileAddress}"/>
        </div>

        <a class="button" href="${pageContext.request.contextPath}/orders">View my orders</a>
    </main>

</body>
</html>