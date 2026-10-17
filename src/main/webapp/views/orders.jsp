<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <title>My Orders | Veloci</title>
    <style>body{background:#f7f7f5;color:#171717}.brand{color:inherit;font-size:1.6rem;font-weight:800;text-decoration:none}.panel{max-width:760px;border:1px solid #eee;border-radius:14px}</style>
</head>
<body>
    <header class="bg-white border-bottom">
        <nav class="container py-3 d-flex justify-content-between align-items-center" aria-label="Main navigation">
            <a class="brand" href="${pageContext.request.contextPath}/home">velo<span class="fw-normal">ci</span></a>
            <a href="${pageContext.request.contextPath}/profile">My profile</a>
        </nav>
    </header>
    <main class="container py-5">
        <section class="panel bg-white p-4 p-md-5 mx-auto">
            <h1 class="h2 mb-3">My orders</h1>
            <p class="text-secondary"><c:choose><c:when test="${param.checkout == 'unavailable'}">Checkout is not configured yet. Your cart has been kept.</c:when><c:otherwise>Your order history will appear here after completed orders.</c:otherwise></c:choose></p>
            <a class="btn btn-dark mt-2" href="${pageContext.request.contextPath}/products">Browse products</a>
        </section>
    </main>
</body>
</html>
