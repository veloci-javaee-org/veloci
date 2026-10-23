<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <title>Login</title><style>
:root{font-family:Arial,Helvetica,sans-serif;color:#171717;background:#f7f7f5}*{box-sizing:border-box}body{margin:0;min-height:100vh;background:#e9e8e3;display:grid;place-items:center;padding:28px}.auth-wrap{width:min(100%,480px);background:#fff;border:1px solid #e8e6df;border-radius:18px;padding:42px;box-shadow:0 18px 55px #17171712}.brand{display:inline-block;font-size:25px;font-weight:800;letter-spacing:-1px;margin-bottom:30px}.brand span{font-weight:400}.form-intro h1{font-size:36px;letter-spacing:-1.5px;margin:0 0 10px}.otherwise{color:#666;margin:0 0 25px}.otherwise a{color:#171717;font-weight:700}.field-input{display:block;width:100%;height:48px;margin:12px 0;padding:0 14px;border:1px solid #d8d7d1;border-radius:7px;background:#fbfbfa;font:inherit}.field-input:focus{outline:2px solid #171717;outline-offset:1px}.send-info{margin-top:20px}input[type=submit]{width:100%;height:48px;border:0;border-radius:7px;background:#171717;color:#fff;font-size:15px;font-weight:700;cursor:pointer}input[type=submit]:hover{background:#333}.error{color:#a52b24;margin:10px 0}.name-row{display:flex;gap:12px}@media(max-width:520px){.auth-wrap{padding:28px 22px}}
</style>
  </head>
  <body>
    <main class="auth-wrap">
      <a class="brand" href="${pageContext.request.contextPath}/home">velo<span>ci</span></a>
      <section class="form-container">
        <section class="form-intro">
          <h1>Login</h1>
          <p class="otherwise">
            Don't have an account? <a href="${pageContext.request.contextPath}/signup">Sign up</a>
          </p>
        </section>
        <c:if test="${not empty param.error}"><div class="error" role="alert"><c:out value="${param.error}"/></div></c:if>
        <c:if test="${param.registered == '1'}"><div class="alert alert-success" role="status">Your account was created. Please sign in.</div></c:if>
        <form id="authForm" action="${pageContext.request.contextPath}/login" name="login" method="POST">
          <label class="visually-hidden" for="identifier">Email or username</label>
          <input
            class="field-input"
            type="text"
            id="identifier"
            name="identifier"
            placeholder="Email or Username"
            autocomplete="username"
            required
          />
          <label class="visually-hidden" for="password">Password</label>
          <input
            class="field-input"
            type="password"
            id="password"
            name="password"
            placeholder="Enter your password"
            autocomplete="current-password"
            required
          />
          <div class="send-info">
            <input type="submit" id="login" value="Login" />
          </div>
        </form>
      </section>
    </main>
  </body>
</html>