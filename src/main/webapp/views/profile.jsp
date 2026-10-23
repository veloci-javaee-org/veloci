<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <title>My Profile | Veloci</title>
    <style>body{background:#f7f7f5;color:#171717}.brand{color:inherit;font-size:1.6rem;font-weight:800;text-decoration:none}.panel{max-width:760px;border:1px solid #eee;border-radius:14px}.profile-row{padding:1rem 0;border-bottom:1px solid #eee}.profile-label{display:block;color:#777;font-size:.85rem}</style>
</head>
<body>
    <header class="bg-white border-bottom">
        <nav class="container py-3 d-flex justify-content-between align-items-center" aria-label="Main navigation">
            <a class="brand" href="${pageContext.request.contextPath}/home">velo<span class="fw-normal">ci</span></a>
            <a href="${pageContext.request.contextPath}/products">Shop</a>
        </nav>
    </header>
    <main class="container py-5">
        <section class="panel bg-white p-4 p-md-5 mx-auto">
            <h1 class="h2 mb-3">My profile</h1>
            <div class="profile-row"><span class="profile-label">Name</span><c:out value="${profileName}"/></div>
            <div class="profile-row"><span class="profile-label">Username</span><c:out value="${sessionScope.username}"/></div>
            <div class="profile-row"><span class="profile-label">Email</span><c:out value="${profileEmail}"/></div>
            <div class="profile-row"><span class="profile-label">Phone</span><c:out value="${profilePhone}"/></div>
            <div class="profile-row"><span class="profile-label">Address</span><c:out value="${profileAddress}"/></div>
            <a class="btn btn-dark mt-4" href="${pageContext.request.contextPath}/orders">View my orders</a>
        </section>
    </main>
</body>
</html>
