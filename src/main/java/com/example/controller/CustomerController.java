package com.example.controller;

import com.example.dao.CustomerDAO;
import com.example.dao.OrderDAO;
import com.example.dao.ProductDAO;
import com.example.model.Customer;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
public class CustomerController {

    @Autowired
    private ProductDAO productDAO;

    @Autowired
    private OrderDAO orderDAO;

    @Autowired
    private CustomerDAO customerDAO;

    // ── Helper to check customer session ──────────────────────────────────────
    private Customer getLoggedCustomer(HttpSession session) {
        Object user = session.getAttribute("loggedUser");
        if (user instanceof Customer) {
            return (Customer) user;
        }
        return null;
    }

    @GetMapping("/customer/orders")
    public String placeOrder(HttpSession session, Model model) {
        Customer c = getLoggedCustomer(session);
        if (c == null) return "redirect:/login";
        
        model.addAttribute("productsList", productDAO.findAll());
        model.addAttribute("customer", c);
        return "customer/place_order";
    }

    @GetMapping("/customer/track")
    public String trackOrder(HttpSession session, Model model) {
        Customer c = getLoggedCustomer(session);
        if (c == null) return "redirect:/login";
        
        model.addAttribute("ordersList", orderDAO.findAllByCustomerId(c.getId()));
        return "customer/track_order";
    }

    @PostMapping("/customer/placeOrder")
    @ResponseBody
    public String processPlaceOrder(HttpSession session, 
                                   @RequestParam Map<String, String> formData) {
        Customer c = getLoggedCustomer(session);
        if (c == null) return "Error: Session expired";

        try {
            List<com.example.model.OrderItem> items = new ArrayList<>();
            BigDecimal grandTotal = BigDecimal.ZERO;
            
            // Format: item_1=qty, item_2=qty...
            for (Map.Entry<String, String> entry : formData.entrySet()) {
                if (entry.getKey().startsWith("qty_")) {
                    int productId = Integer.parseInt(entry.getKey().substring(4));
                    int qty = Integer.parseInt(entry.getValue());
                    
                    if (qty > 0) {
                        com.example.model.Product p = productDAO.findById(productId);
                        // Stock Check
                        if (p.getStock() < qty) {
                            return "Error: " + p.getName() + " has only " + p.getStock() + " in stock.";
                        }
                        
                        com.example.model.OrderItem item = new com.example.model.OrderItem();
                        item.setProductId(productId);
                        item.setQuantity(qty);
                        item.setUnitPrice(p.getPrice());
                        BigDecimal itemTotal = p.getPrice().multiply(new BigDecimal(qty));
                        item.setTotalPrice(itemTotal);
                        grandTotal = grandTotal.add(itemTotal);
                        items.add(item);
                        
                        // Deduct Stock
                        productDAO.reduceStock(productId, qty);
                    }
                }
            }

            if (items.isEmpty()) return "Error: No items selected";

            com.example.model.Order order = new com.example.model.Order();
            order.setOrderNumber("ORD-" + System.currentTimeMillis());
            order.setCustomerId(c.getId());
            order.setTotalAmount(grandTotal);
            order.setStatus("Processing");
            order.setDeliveryPriority(formData.getOrDefault("urgency", "Regular"));

            orderDAO.saveOrderWithItems(order, items);
            return "Success:" + order.getOrderNumber();

        } catch (Exception e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        }
    }

    @PostMapping("/customer/updatePassword")
    public String updatePassword(HttpSession session,
                                @RequestParam("newPassword") String newPassword,
                                @RequestParam("confirmPassword") String confirmPassword,
                                RedirectAttributes ra) {
        Customer c = getLoggedCustomer(session);
        if (c == null) return "redirect:/login";

        if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("passError", "Passwords do not match!");
            return "redirect:/customer/profile";
        }

        String hashed = org.mindrot.jbcrypt.BCrypt.hashpw(newPassword, org.mindrot.jbcrypt.BCrypt.gensalt());
        customerDAO.updatePassword(c.getId(), hashed);
        
        ra.addFlashAttribute("passSuccess", "Password updated successfully!");
        return "redirect:/customer/profile";
    }

    @PostMapping("/customer/cancelOrder")
    public String cancelOrder(@RequestParam("orderId") int orderId, HttpSession session) {
        Customer c = getLoggedCustomer(session);
        if (c == null) return "redirect:/login";
        
        // Check if order belongs to customer and is still Processing
        com.example.model.Order order = orderDAO.findById(orderId);
        if (order != null && order.getCustomerId() == c.getId() && "Processing".equalsIgnoreCase(order.getStatus())) {
            orderDAO.cancelOrder(orderId);
        }
        return "redirect:/customer/track";
    }

    @GetMapping("/customer/profile")
    public String viewProfile(HttpSession session, Model model) {
        Customer c = getLoggedCustomer(session);
        if (c == null) return "redirect:/login";
        
        model.addAttribute("customer", customerDAO.findById(c.getId()));
        return "customer/profile";
    }
}
