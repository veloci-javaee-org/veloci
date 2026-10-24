<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- Inner content of the cart drawer. Included on page load by cart-drawer.jsp
     and returned on its own to the browser after every AJAX cart action. --%>
<c:set var="subtotal" value="0"/>
<c:set var="count" value="0"/>
<c:forEach var="item" items="${sessionScope.cartItems}">
    <c:set var="subtotal" value="${subtotal + item.lineTotal}"/>
    <c:set var="count" value="${count + item.quantity}"/>
</c:forEach>

<div id="cartState" data-count="${count}" hidden></div>

<c:choose>
    <c:when test="${empty sessionScope.cartItems}">
        <div class="vc-empty">
            <div class="vc-empty-icon">&#128722;</div>
            <h3>Your cart is empty</h3>
            <p>Looks like you haven't added anything yet.</p>
            <a class="vc-btn" href="${pageContext.request.contextPath}/products">Browse products</a>
        </div>
    </c:when>
    <c:otherwise>
        <ul class="vc-items">
            <c:forEach var="item" items="${sessionScope.cartItems}" varStatus="st">
                <li class="vc-item">
                    <div class="vc-thumb">
                        <c:if test="${not empty item.product.images}">
                            <img src="${pageContext.request.contextPath}/${item.product.images[0].imagePath}" alt="<c:out value='${item.product.name}'/>">
                        </c:if>
                    </div>
                    <div class="vc-info">
                        <div class="vc-row">
                            <strong class="vc-name"><c:out value="${item.product.name}"/></strong>
                            <button type="button" class="vc-remove" data-cart-action="remove"
                                    data-index="${st.index}" aria-label="Remove <c:out value='${item.product.name}'/>">&times;</button>
                        </div>
                        <span class="vc-meta">
                            <c:if test="${not empty item.size}">Size <c:out value="${item.size}"/> · </c:if>Quantity: ${item.quantity}
                        </span>
                        <div class="vc-row vc-bottom">
                            <div class="vc-qty">
                                <button type="button" data-cart-action="update" data-index="${st.index}"
                                        data-quantity="${item.quantity - 1}" aria-label="Decrease quantity">&minus;</button>
                                <span>${item.quantity}</span>
                                <button type="button" data-cart-action="update" data-index="${st.index}"
                                        data-quantity="${item.quantity + 1}" aria-label="Increase quantity"
                                        ${item.quantity >= item.product.stock ? 'disabled' : ''}>+</button>
                            </div>
                            <span class="vc-price">$<fmt:formatNumber value="${item.lineTotal}" pattern="#,##0.00"/></span>
                        </div>
                    </div>
                </li>
            </c:forEach>
        </ul>

        <div class="vc-footer">
            <div class="vc-line"><span>Subtotal</span><strong>$<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></strong></div>
            <p class="vc-note">Shipping calculated at checkout.</p>
            <a class="vc-btn vc-btn-block" href="${pageContext.request.contextPath}/checkout">Checkout</a>
            <button type="button" class="vc-link" data-cart-close>Continue shopping</button>
        </div>
    </c:otherwise>
</c:choose>