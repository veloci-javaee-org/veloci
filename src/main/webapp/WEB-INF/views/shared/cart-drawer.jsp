<%@ page contentType="text/html;charset=UTF-8" %>
<%-- Include once per page, just before </body>:
     <jsp:include page="/WEB-INF/views/shared/cart-drawer.jsp"/>
     Open it with any link/button that has the attribute data-cart-open.
     Add-to-cart forms get AJAX behaviour with the attribute data-cart-add. --%>
<style>
.vc-overlay{position:fixed;inset:0;background:rgba(0,0,0,.45);opacity:0;visibility:hidden;transition:opacity .3s,visibility .3s;z-index:1000}
.vc-overlay.open{opacity:1;visibility:visible}
.vc-drawer{position:fixed;top:0;left:0;bottom:0;width:min(420px,100%);background:#fff;z-index:1001;display:flex;flex-direction:column;transform:translateX(-100%);transition:transform .35s cubic-bezier(.4,0,.2,1);box-shadow:8px 0 40px rgba(0,0,0,.15);font-family:Arial,Helvetica,sans-serif;color:#171717}
.vc-drawer.open{transform:translateX(0)}
.vc-head{display:flex;align-items:center;justify-content:space-between;padding:20px 24px;border-bottom:1px solid #eee}
.vc-head h2{margin:0;font-size:20px;letter-spacing:-.5px}
.vc-head h2 span{color:#888;font-weight:400;font-size:15px}
.vc-close{border:0;background:none;font-size:28px;line-height:1;cursor:pointer;color:#555;padding:4px 8px;border-radius:6px}
.vc-close:hover{background:#f3f3f0;color:#000}
.vc-body{flex:1;overflow-y:auto;display:flex;flex-direction:column}
.vc-body.loading{opacity:.55;pointer-events:none}
.vc-items{list-style:none;margin:0;padding:8px 24px;flex:1}
.vc-item{display:flex;gap:14px;padding:18px 0;border-bottom:1px solid #f0f0ed}
.vc-thumb{width:80px;height:96px;flex:none;border-radius:8px;background:#e9e8e3;overflow:hidden}
.vc-thumb img{width:100%;height:100%;object-fit:cover;display:block}
.vc-info{flex:1;min-width:0;display:flex;flex-direction:column;gap:4px}
.vc-row{display:flex;justify-content:space-between;align-items:flex-start;gap:8px}
.vc-name{font-size:15px;line-height:1.3}
.vc-meta{font-size:13px;color:#888}
.vc-remove{border:0;background:none;font-size:22px;line-height:1;color:#aaa;cursor:pointer;padding:0 4px}
.vc-remove:hover{color:#a52b24}
.vc-bottom{margin-top:auto;align-items:center}
.vc-qty{display:inline-flex;align-items:center;border:1px solid #ddd;border-radius:7px}
.vc-qty button{width:30px;height:30px;border:0;background:none;font-size:17px;cursor:pointer}
.vc-qty button:hover:not(:disabled){background:#f3f3f0}
.vc-qty button:disabled{color:#ccc;cursor:not-allowed}
.vc-qty span{min-width:28px;text-align:center;font-size:14px}
.vc-price{font-weight:700;font-size:15px}
.vc-footer{padding:20px 24px 24px;border-top:1px solid #eee;background:#fafaf8}
.vc-line{display:flex;justify-content:space-between;font-size:17px}
.vc-note{color:#888;font-size:13px;margin:6px 0 16px}
.vc-btn{display:inline-block;padding:13px 22px;background:#171717;color:#fff;border:0;border-radius:7px;font:600 14px Arial,sans-serif;cursor:pointer;text-decoration:none;text-align:center}
.vc-btn:hover{background:#333}
.vc-btn-block{display:block;width:100%}
.vc-link{display:block;width:100%;margin-top:10px;border:0;background:none;color:#555;font:inherit;font-size:13px;text-decoration:underline;cursor:pointer}
.vc-empty{flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:40px 24px}
.vc-empty-icon{font-size:42px;margin-bottom:10px}
.vc-empty h3{margin:0 0 6px}
.vc-empty p{color:#888;margin:0 0 20px;font-size:14px}
body.vc-lock{overflow:hidden}
.vc-badge{display:inline-block;min-width:18px;padding:1px 6px;margin-left:4px;border-radius:9px;background:#171717;color:#fff;font-size:11px;text-align:center}
.vc-badge:empty,.vc-badge[data-zero]{display:none}
</style>

<div class="vc-overlay" id="cartOverlay" data-cart-close></div>

<aside class="vc-drawer" id="cartDrawer" role="dialog" aria-modal="true" aria-labelledby="cartTitle" aria-hidden="true">
    <div class="vc-head">
        <h2 id="cartTitle">Your cart <span id="cartHeadCount"></span></h2>
        <button type="button" class="vc-close" data-cart-close aria-label="Close cart">&times;</button>
    </div>
    <div class="vc-body" id="cartBody">
        <jsp:include page="/WEB-INF/views/shared/cart-drawer-items.jsp"/>
    </div>
</aside>

<script>
(function () {
    var ctx = '<%= request.getContextPath() %>';
    var drawer = document.getElementById('cartDrawer');
    var overlay = document.getElementById('cartOverlay');
    var body = document.getElementById('cartBody');
    var lastFocus = null;

    function open() {
        lastFocus = document.activeElement;
        drawer.classList.add('open');
        overlay.classList.add('open');
        drawer.setAttribute('aria-hidden', 'false');
        document.body.classList.add('vc-lock');
        var c = drawer.querySelector('.vc-close');
        if (c) c.focus();
    }
    function close() {
        drawer.classList.remove('open');
        overlay.classList.remove('open');
        drawer.setAttribute('aria-hidden', 'true');
        document.body.classList.remove('vc-lock');
        if (lastFocus && lastFocus.focus) lastFocus.focus();
    }

    function syncCount() {
        var s = document.getElementById('cartState');
        var n = s ? parseInt(s.getAttribute('data-count'), 10) || 0 : 0;
        var head = document.getElementById('cartHeadCount');
        if (head) head.textContent = n ? '(' + n + ')' : '';
        document.querySelectorAll('[data-cart-count]').forEach(function (el) {
            el.textContent = n;
            if (n) el.removeAttribute('data-zero'); else el.setAttribute('data-zero', '');
        });
    }

    // Send a cart action; the server answers with the refreshed drawer HTML.
    function send(params) {
        body.classList.add('loading');
        return fetch(ctx + '/cart', {
            method: 'POST',
            credentials: 'same-origin',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: new URLSearchParams(params).toString()
        }).then(function (res) {
            // Filter redirects guests to the login page
            if (res.redirected && res.url.indexOf('login') !== -1) {
                window.location.href = ctx + '/login';
                return null;
            }
            if (!res.ok) throw new Error('Cart request failed');
            return res.text();
        }).then(function (html) {
            if (html === null) return;
            body.innerHTML = html;
            syncCount();
        }).catch(function () {
            alert('Could not update the cart. Please try again.');
        }).then(function () {
            body.classList.remove('loading');
        });
    }

    document.addEventListener('click', function (e) {
        var t = e.target;
        var openEl = t.closest('[data-cart-open]');
        if (openEl) { e.preventDefault(); open(); return; }
        if (t.closest('[data-cart-close]')) { close(); return; }
        var act = t.closest('[data-cart-action]');
        if (act && !act.disabled) {
            var p = { action: act.getAttribute('data-cart-action'), index: act.getAttribute('data-index') };
            if (p.action === 'update') p.quantity = act.getAttribute('data-quantity');
            send(p);
        }
    });

    document.addEventListener('submit', function (e) {
        var f = e.target;
        if (!f.hasAttribute || !f.hasAttribute('data-cart-add')) return;
        e.preventDefault();
        var p = { action: 'add' };
        new FormData(f).forEach(function (v, k) { p[k] = v; });
        send(p).then(open);
    });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && drawer.classList.contains('open')) close();
    });

    window.VelociCart = { open: open, close: close };
    syncCount();
})();
</script>
