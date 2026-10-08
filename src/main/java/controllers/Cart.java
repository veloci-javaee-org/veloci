package controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import dao.ProductDAO;
import dao.ProductDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Product;

@WebServlet("/cart")
public class Cart extends HttpServlet {
 private static final long serialVersionUID=1L;
 @SuppressWarnings("unchecked") protected void doPost(HttpServletRequest req,HttpServletResponse res)throws IOException {
  Product product=new ProductDAOImpl().getProductById(parse(req.getParameter("productId")));
  if(product==null||product.getCategory()==null||!"Clothing".equalsIgnoreCase(product.getCategory().getName())){res.sendRedirect(req.getContextPath()+"/products");return;}
  String size=req.getParameter("size");int quantity=Math.max(1,Math.min(product.getStock(),parse(req.getParameter("quantity"))));
  if(size==null||!size.matches("XS|S|M|L|XL|XXL")){res.sendRedirect(req.getContextPath()+"/product-details?id="+product.getId());return;}
  HttpSession session=req.getSession();List<Map<String,Object>> items=(List<Map<String,Object>>)session.getAttribute("cartItems");if(items==null){items=new ArrayList<>();session.setAttribute("cartItems",items);}
  Map<String,Object> item=new LinkedHashMap<>();item.put("product",product);item.put("size",size);item.put("quantity",quantity);item.put("lineTotal",product.getPrice()*quantity);items.add(item);
  res.sendRedirect(req.getContextPath()+"/cart");
 }
 @SuppressWarnings("unchecked") protected void doGet(HttpServletRequest req,HttpServletResponse res)throws ServletException,IOException {
  List<Map<String,Object>> items=(List<Map<String,Object>>)req.getSession().getAttribute("cartItems");double total=0;if(items!=null)for(Map<String,Object> item:items)total+=(Double)item.get("lineTotal");req.setAttribute("cartItems",items);req.setAttribute("cartTotal",total);req.getRequestDispatcher("/views/cart.jsp").forward(req,res);
 }
 private int parse(String value){try{return Integer.parseInt(value);}catch(Exception e){return 1;}}
}
