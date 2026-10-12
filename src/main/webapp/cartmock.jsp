<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Shopping Cart Mockup</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 40px;
        background-color: #f4f4f9;
    }
    .cart-container {
        max-width: 400px;
        background: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    .btn-checkout {
        background-color: #28a745;
        color: white;
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        border-radius: 4px;
        cursor: pointer;
        width: 100%;
    }
    .btn-checkout:hover {
        background-color: #218838;
    }
</style>
</head>
<body>

<div class="cart-container">
    <h2>Your Shopping Cart</h2>
    <p>Items in cart: <strong>3 items</strong></p>
    
    <!-- Read the attribute safely using Expression Language (EL) -->
    <p>Total Price: <strong>$${sessionScope.totalPrice}</strong></p>
    <hr>
    
    <!-- Form pointing to the Checkout Servlet -->
    <form action="checkout.jsp" method="POST">
        <button type="submit" class="btn-checkout">Proceed to Checkout</button>
    </form>
</div>

</body>
</html>