<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <title><c:out value="${product.name}"/> - Veloci</title>
    <style>
        *{box-sizing:border-box}
        body{margin:0;background:#f7f7f5;color:#171717;font:16px Arial,sans-serif}
        a{color:inherit;text-decoration:none}
        .navbar{height:72px;padding:0 7%;display:flex;align-items:center;justify-content:space-between;background:#fff;border-bottom:1px solid #eee}
        .logo{font-size:27px;font-weight:800;letter-spacing:-1px}.logo span{font-weight:400}
        .details-container{max-width:1100px;margin:45px auto;padding:0 24px}
        .gallery{position:relative;min-width:0}
        .image-gallery{display:flex;gap:0;overflow-x:auto;overscroll-behavior-x:contain;scroll-snap-type:x mandatory;scroll-behavior:smooth;border-radius:12px;scrollbar-width:thin;touch-action:pan-x pan-y}
        .image-gallery img{flex:0 0 100%;width:100%;height:min(65vw,560px);min-height:300px;object-fit:contain;background:#fff;border-radius:12px;scroll-snap-align:center}
        .gallery-control{position:absolute;top:50%;transform:translateY(-50%);width:42px;height:42px;border:0;border-radius:50%;background:#fff;color:#171717;font-size:24px;box-shadow:0 2px 12px #0002;cursor:pointer}
        .gallery-control:focus-visible,.thumbnail:focus-visible{outline:3px solid #171717;outline-offset:2px}
        .gallery-prev{left:12px}.gallery-next{right:12px}
        .thumbnails{display:flex;gap:8px;overflow-x:auto;padding:12px 2px}
        .thumbnail{width:64px;height:64px;flex:0 0 64px;padding:0;border:2px solid transparent;border-radius:8px;background:#fff;overflow:hidden;cursor:pointer}
        .thumbnail img{width:100%;height:100%;object-fit:cover}
        .thumbnail[aria-current=true]{border-color:#171717}
        .no-image{min-height:300px;display:grid;place-items:center;background:#fff;border-radius:12px;color:#777}
        .info{padding:24px}.info h1{font-size:38px;letter-spacing:-1px}
        .price{font-size:24px;font-weight:bold}
        .btn{padding:13px 20px;background:#171717;color:white;border:0;border-radius:7px;display:inline-block;margin-top:20px;cursor:pointer}
        select,input{padding:11px;border:1px solid #ccc;border-radius:6px}
        .purchase{display:flex;gap:12px;align-items:end;flex-wrap:wrap;margin-top:20px}
        .purchase label{display:grid;gap:6px;font-weight:600}
        .purchase input{min-height:44px}
        @media(max-width:700px){.details-container{grid-template-columns:1fr;margin:20px auto}.info{padding:0}.info h1{font-size:32px}.image-gallery img{height:100vw;min-height:260px;max-height:520px}}
    </style>
</head>
<body>
<header class="navbar"><a href="${pageContext.request.contextPath}/home" class="logo">velo<span>ci</span></a><nav><a href="${pageContext.request.contextPath}/home">Home</a> &nbsp; <a href="${pageContext.request.contextPath}/products">Shop</a></nav><c:if test="${sessionScope.role == 'CUSTOMER'}"><a href="${pageContext.request.contextPath}/cart" data-cart-open>Cart<span class="vc-badge" data-cart-count></span></a></c:if></header>
    <div style="max-width:1100px;margin:26px auto 0;padding:0 24px"><a href="${pageContext.request.contextPath}/products">&larr; Back to Products</a></div>
    
    <div class="details-container row g-4 align-items-start">
        <div class="gallery col-lg-6">
            <c:choose>
                <c:when test="${not empty product.images}">
                    <div class="image-gallery" id="productGallery" aria-label="Product images">
                        <c:forEach var="img" items="${product.images}" varStatus="imageStatus">
                            <img id="product-image-${imageStatus.index}"
                                 src="${pageContext.request.contextPath}/${img.imagePath}"
                                 alt="<c:out value='${product.name}'/> image ${imageStatus.index + 1}">
                        </c:forEach>
                    </div>
                    <c:if test="${product.images.size() > 1}">
                        <button class="gallery-control gallery-prev" type="button" aria-label="Previous image">&#8249;</button>
                        <button class="gallery-control gallery-next" type="button" aria-label="Next image">&#8250;</button>
                        <div class="thumbnails" aria-label="Choose product image">
                            <c:forEach var="img" items="${product.images}" varStatus="imageStatus">
                                <button class="thumbnail" type="button" data-slide-to="${imageStatus.index}"
                                        aria-label="Show image ${imageStatus.index + 1}"
                                        aria-current="${imageStatus.first}">
                                    <img src="${pageContext.request.contextPath}/${img.imagePath}" alt="">
                                </button>
                            </c:forEach>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise><div class="no-image">Product image coming soon</div></c:otherwise>
            </c:choose>
        </div>
        
        <div class="info col-lg-6">
            <h1><c:out value="${product.name}"/></h1>
            <p><strong>Category:</strong> <c:out value="${product.category.name}"/></p>
            <p class="price">$${product.price}</p>
            <p><strong>Available Stock:</strong> ${product.stock}</p>
            <p><strong>Description:</strong> <c:out value="${product.description}"/></p>
            
            <c:choose>
                <c:when test="${product.stock > 0 && sessionScope.role == 'CUSTOMER'}">
                    <form action="${pageContext.request.contextPath}/cart" method="POST" class="purchase" data-cart-add>
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${product.id}">
                        <label for="qty">Quantity:
                            <input type="number" id="qty" name="quantity" value="1" min="1" max="${product.stock}" required>
                        </label>
                        <button type="submit" class="btn">Add to Cart</button>
                    </form>
                </c:when>
                <c:when test="${product.stock > 0}"><p><a class="btn" href="${pageContext.request.contextPath}/login">Log in to add this product to your cart</a></p></c:when>
                <c:otherwise><p role="status">This product is currently out of stock.</p></c:otherwise>
            </c:choose>
        </div>
    </div>

    <c:if test="${sessionScope.role == 'CUSTOMER'}"><jsp:include page="/views/cart-drawer.jsp"/></c:if>
    <script>
        (function () {
            var gallery = document.getElementById("productGallery");
            if (!gallery) return;
            var thumbnails = Array.from(document.querySelectorAll(".thumbnail"));
            var scrollToImage = function (index) {
                var image = gallery.children[index];
                if (image) gallery.scrollTo({left: gallery.clientWidth * index, behavior: "smooth"});
            };
            var previous = document.querySelector(".gallery-prev");
            var next = document.querySelector(".gallery-next");
            if (previous) previous.addEventListener("click", function () {
                gallery.scrollBy({left: -gallery.clientWidth, behavior: "smooth"});
            });
            if (next) next.addEventListener("click", function () {
                gallery.scrollBy({left: gallery.clientWidth, behavior: "smooth"});
            });
            thumbnails.forEach(function (thumbnail) {
                thumbnail.addEventListener("click", function () {
                    scrollToImage(Number(thumbnail.dataset.slideTo));
                    thumbnails.forEach(function (item) { item.setAttribute("aria-current", "false"); });
                    thumbnail.setAttribute("aria-current", "true");
                });
            });
            gallery.addEventListener("scroll", function () {
                var current = Math.round(gallery.scrollLeft / gallery.clientWidth);
                thumbnails.forEach(function (item, index) {
                    item.setAttribute("aria-current", index === current ? "true" : "false");
                });
            });
        }());
    </script>
</body>
</html>