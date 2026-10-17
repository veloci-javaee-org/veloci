<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
                <title>Shop | Veloci</title>
                <style>
                    * {
                        box-sizing: border-box
                    }

                    body {
                        margin: 0;
                        background: #f7f7f5;
                        color: #171717;
                        font-family: Arial, Helvetica, sans-serif
                    }

                    a {
                        text-decoration: none;
                        color: inherit
                    }

                    .navbar {
                        height: 72px;
                        padding: 0 7%;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        background: #fff;
                        border-bottom: 1px solid #eee
                    }

                    .logo {
                        font-size: 27px;
                        font-weight: 800;
                        letter-spacing: -1px
                    }

                    .logo span {
                        font-weight: 400
                    }

                    .nav-links,
                    .actions {
                        display: flex;
                        align-items: center;
                        gap: 26px;
                        list-style: none
                    }

                    .nav-links a {
                        color: #555
                    }

                    .actions {
                        gap: 16px
                    }

                    .profile-menu {
                        position: relative
                    }

                    .profile-menu summary {
                        list-style: none;
                        cursor: pointer
                    }

                    .profile-menu summary::-webkit-details-marker {
                        display: none
                    }

                    .profile-options {
                        position: absolute;
                        right: 0;
                        top: calc(100% + 10px);
                        z-index: 5;
                        min-width: 165px;
                        padding: 8px;
                        background: #fff;
                        border: 1px solid #eee;
                        border-radius: 9px;
                        box-shadow: 0 8px 24px #0002
                    }

                    .profile-options a,
                    .profile-options button {
                        display: block;
                        width: 100%;
                        padding: 10px;
                        border: 0;
                        background: none;
                        text-align: left;
                        font: inherit;
                        cursor: pointer
                    }

                    .profile-options a:hover,
                    .profile-options button:hover {
                        background: #f5f5f2
                    }

                    .button {
                        display: inline-block;
                        padding: 11px 17px;
                        border-radius: 7px;
                        background: #171717;
                        color: white;
                        border: 0;
                        font-weight: 600;
                        cursor: pointer
                    }

                    .button.light {
                        background: #fff;
                        color: #171717;
                        border: 1px solid #ccc
                    }

                    .wrap {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 45px 24px
                    }

                    .heading {
                        display: flex;
                        justify-content: space-between;
                        align-items: end;
                        margin-bottom: 26px
                    }

                    .heading h1 {
                        font-size: 42px;
                        letter-spacing: -2px;
                        margin: 0 0 8px
                    }

                    .heading p {
                        color: #666;
                        margin: 0
                    }

                    .filters {
                        display: flex;
                        gap: 12px;
                        flex-wrap: wrap;
                        background: #fff;
                        border: 1px solid #eee;
                        border-radius: 12px;
                        padding: 18px;
                        margin-bottom: 28px
                    }

                    .filters input,
                    .filters select {
                        min-height: 42px;
                        padding: 0 12px;
                        border: 1px solid #ddd;
                        border-radius: 7px;
                        background: #fff;
                        font: inherit
                    }

                    .filters input[type=search] {
                        flex: 1;
                        min-width: 200px
                    }

                    .grid.row {
                        display: flex;
                        grid-template-columns: none
                    }

                    .card {
                        background: #fff;
                        border: 1px solid #eee;
                        border-radius: 16px;
                        padding: 12px;
                        overflow: hidden;
                        transition: transform .2s, box-shadow .2s
                    }

                    .card:hover,
                    .card:focus-within {
                        transform: translateY(-4px);
                        box-shadow: 0 16px 36px #17171716
                    }

                    .card-link {
                        display: block;
                        height: 100%;
                        border-radius: 10px
                    }

                    .card-link:focus-visible {
                        outline: 3px solid #171717;
                        outline-offset: 4px
                    }

                    .product-photo {
                        width: 100%;
                        height: 250px;
                        display: grid;
                        place-items: center;
                        overflow: hidden;
                        border-radius: 10px;
                        background: #f3f3f1
                    }

                    .card img {
                        width: 100%;
                        height: 100%;
                        object-fit: contain;
                        transition: transform .25s
                    }

                    .card:hover img {
                        transform: scale(1.035)
                    }

                    .card-content {
                        padding: 5px 5px 7px
                    }

                    .product-category {
                        display: inline-block;
                        margin-top: 12px;
                        color: #737373;
                        font-size: 12px;
                        font-weight: 700;
                        letter-spacing: .06em;
                        text-transform: uppercase
                    }

                    .card h2 {
                        font-size: 18px;
                        line-height: 1.35;
                        margin: 7px 0
                    }

                    .muted {
                        color: #777;
                        font-size: 14px
                    }

                    .product-description {
                        display: -webkit-box;
                        min-height: 40px;
                        overflow: hidden;
                        color: #777;
                        font-size: 13px;
                        line-height: 1.5;
                        -webkit-box-orient: vertical;
                        -webkit-line-clamp: 2
                    }

                    .price {
                        font-size: 19px;
                        font-weight: 700;
                        margin: 12px 0 10px
                    }

                    .card-action {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        padding-top: 12px;
                        border-top: 1px solid #f0f0ee;
                        color: #333;
                        font-size: 13px;
                        font-weight: 700
                    }

                    .empty {
                        padding: 45px;
                        text-align: center;
                        background: #fff;
                        border-radius: 12px;
                        color: #666
                    }

                    @media(max-width:680px) {
                        .navbar {
                            padding: 0 18px
                        }

                        .nav-links {
                            gap: 12px
                        }

                        .nav-links li:nth-child(3) {
                            display: none
                        }

                        .heading {
                            display: block
                        }

                        .heading h1 {
                            font-size: 34px
                        }
                    }
                </style>
            </head>

            <body>
                <header class="navbar"><a href="${pageContext.request.contextPath}/home"
                        class="logo">velo<span>ci</span></a>
                    <ul class="nav-links">
                        <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/products">Shop</a></li>
                        <li><a href="${pageContext.request.contextPath}/products?category=Clothing">Clothing</a></li>
                    </ul>
                    <div class="actions">
                        <c:choose>
                            <c:when test="${sessionScope.role == 'ADMIN'}">
                                <a href="${pageContext.request.contextPath}/admin" class="button">Admin dashboard</a>
                                <form action="${pageContext.request.contextPath}/logout" method="post"><button class="button light" type="submit">Log out</button></form>
                            </c:when>
                            <c:when test="${not empty sessionScope.username}"><a
                                    href="${pageContext.request.contextPath}/cart" data-cart-open>Cart<span
                                        class="vc-badge" data-cart-count></span></a>
                                <details class="profile-menu">
                                    <summary class="button">Profile</summary>
                                    <div class="profile-options"><a href="${pageContext.request.contextPath}/profile">My
                                            profile</a><a href="${pageContext.request.contextPath}/orders">My orders</a>
                                        <form action="${pageContext.request.contextPath}/logout" method="post"><button
                                                type="submit">Log out</button></form>
                                    </div>
                                </details>
                            </c:when>
                            <c:otherwise><a href="${pageContext.request.contextPath}/login"
                                    class="button light">Login</a></c:otherwise>
                        </c:choose>
                    </div>
                </header>
                <main class="wrap">
                    <div class="heading">
                        <div>
                            <h1>Shop our collection</h1>
                            <p>Browse everything the store has to offer.</p>
                        </div><a class="button light" href="${pageContext.request.contextPath}/home">← Home</a>
                    </div>
                    <form class="filters" action="${pageContext.request.contextPath}/products" method="get"><input
                            type="search" name="keyword" placeholder="Search products" value="${searchKeyword}"><select
                            name="category">
                            <option value="">All categories</option>
                            <c:forEach var="categoryOption" items="${categories}">
                                <option value="${categoryOption.name}" ${selectedCategory==categoryOption.name
                                    ? 'selected' : '' }>${categoryOption.name}</option>
                            </c:forEach>
                        </select><select name="sort">
                            <option value="">Sort: featured</option>
                            <option value="price_asc" ${sort=='price_asc' ? 'selected' : '' }>Price: low to high
                            </option>
                            <option value="price_desc" ${sort=='price_desc' ? 'selected' : '' }>Price: high to low
                            </option>
                            <option value="name" ${sort=='name' ? 'selected' : '' }>Name</option>
                        </select><button class="button" type="submit">Apply</button><a class="button light"
                            href="${pageContext.request.contextPath}/products">Reset</a></form>
                    <c:choose>
                        <c:when test="${empty products}">
                            <div class="empty">No products found. Try changing your search or filter.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="grid row row-cols-1 row-cols-sm-2 row-cols-lg-3 row-cols-xl-4 g-4">
                                <c:forEach var="product" items="${products}">
                                    <article class="col"><div class="card h-100">
                                        <a class="card-link"
                                           href="${pageContext.request.contextPath}/product-details?id=${product.id}"
                                           aria-label="View details for ${product.name}">
                                            <div class="product-photo">
                                                <c:choose>
                                                    <c:when test="${not empty product.images}">
                                                        <img src="${pageContext.request.contextPath}/${product.images[0].imagePath}"
                                                             alt="${product.name}" loading="lazy">
                                                    </c:when>
                                                    <c:otherwise><span class="muted">Image coming soon</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="card-content">
                                                <span class="product-category"><c:out value="${product.category.name}"/></span>
                                                <h2><c:out value="${product.name}"/></h2>
                                                <p class="product-description"><c:out value="${product.description}"/></p>
                                                <p class="price">$<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></p>
                                                <span class="card-action">View product details <span aria-hidden="true">&rarr;</span></span>
                                            </div>
                                        </a>
                                    </div></article>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </main>
                <c:if test="${sessionScope.role == 'CUSTOMER'}"><jsp:include page="/views/cart-drawer.jsp" /></c:if>
            </body>

            </html>