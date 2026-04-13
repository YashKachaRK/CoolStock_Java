package com.example.controller;

import com.example.dao.OrderDAO;
import com.example.dao.ProductDAO;
import com.example.dao.StaffDAO;
import com.example.model.Staff;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/manager")
public class ManagerController {

    @Autowired
    private OrderDAO orderDAO;

    @Autowired
    private StaffDAO staffDAO;

    @Autowired
    private ProductDAO productDAO;

    private boolean checkSession(HttpSession session) {
        Staff staff = (Staff) session.getAttribute("staff");
        return staff != null && "Manager".equals(staff.getRole());
    }

    @GetMapping("/dashboard")
    public String showDashboard(HttpSession session, Model model) {
        if (!checkSession(session)) return "redirect:/login";

        model.addAttribute("pendingOrders", orderDAO.findProcessingOrders());
        model.addAttribute("assignedOrders", orderDAO.findAssignedOrders());
        model.addAttribute("deliveryBoys", staffDAO.findByRole("Delivery"));
        
        // Enhanced Stats
        model.addAttribute("totalRevenue", orderDAO.getTotalRevenue());
        model.addAttribute("productCount", productDAO.countTotalProducts());
        model.addAttribute("lowStockCount", productDAO.countLowStock(10));
        
        model.addAttribute("countPending", orderDAO.countOrdersByStatus("Processing"));
        model.addAttribute("countShipped", orderDAO.countOrdersByStatus("Shipped"));
        model.addAttribute("countDeliveredToday", orderDAO.countTotalDelivered());
        model.addAttribute("countTotalToday", orderDAO.countOrdersToday());

        return "manager/dashboard";
    }

    @GetMapping("/orders")
    public String viewOrders(HttpSession session, Model model) {
        if (!checkSession(session)) return "redirect:/login";
        model.addAttribute("ordersList", orderDAO.findAllWithDetails());
        model.addAttribute("deliveryBoys", staffDAO.findByRole("Delivery"));
        model.addAttribute("countUrgent", orderDAO.countUrgentOrders());
        model.addAttribute("countTotal", orderDAO.countOrdersByStatus("Processing") + orderDAO.countOrdersByStatus("Shipped") + orderDAO.countOrdersByStatus("Delivered"));
        model.addAttribute("countProcessing", orderDAO.countOrdersByStatus("Processing"));
        model.addAttribute("countDelivered", orderDAO.countOrdersByStatus("Delivered"));
        return "manager/target_orders";
    }

    @GetMapping("/products")
    public String viewProducts(HttpSession session, Model model) {
        if (!checkSession(session)) return "redirect:/login";
        model.addAttribute("productsList", productDAO.findAll());
        return "manager/view_products";
    }

    @GetMapping("/profile")
    public String viewProfile(HttpSession session, Model model) {
        if (!checkSession(session)) return "redirect:/login";
        model.addAttribute("manager", session.getAttribute("staff"));
        return "manager/profile";
    }

    @PostMapping("/assignOrder")
    public String assignOrder(@RequestParam("orderId") int orderId, @RequestParam("staffId") int staffId, HttpSession session) {
        if (!checkSession(session)) return "redirect:/login";
        orderDAO.assignDeliveryBoy(orderId, staffId);
        return "redirect:/manager/orders";
    }

    @PostMapping("/products/add")
    public String addProduct(
            @RequestParam("name") String name,
            @RequestParam("category") String category,
            @RequestParam("flavor") String flavor,
            @RequestParam("price") java.math.BigDecimal price,
            @RequestParam("stock") int stock,
            @RequestParam("pcsPerBox") int pcsPerBox,
            @RequestParam("description") String description,
            HttpSession session) {
        
        if (!checkSession(session)) return "redirect:/login";
        
        com.example.model.Product p = new com.example.model.Product();
        p.setProductCode("PROD-" + System.currentTimeMillis());
        p.setName(name);
        p.setCategory(category);
        p.setFlavor(flavor);
        p.setPrice(price);
        p.setStock(stock);
        p.setPcsPerBox(pcsPerBox);
        p.setDescription(description);
        
        productDAO.save(p);
        return "redirect:/manager/products";
    }

    @PostMapping("/products/quickRestock")
    @ResponseBody
    public String quickRestock(@RequestParam("id") int id, @RequestParam("amount") int amount, HttpSession session) {
        if (!checkSession(session)) return "Error: Unauthorized";
        productDAO.addStock(id, amount);
        return "Success";
    }

    @PostMapping("/products/edit")
    public String updateProduct(
            @RequestParam("productCode") String productCode,
            @RequestParam("name") String name,
            @RequestParam("category") String category,
            @RequestParam("flavor") String flavor,
            @RequestParam("price") java.math.BigDecimal price,
            @RequestParam("stock") int stock,
            @RequestParam("pcsPerBox") int pcsPerBox,
            @RequestParam("description") String description,
            HttpSession session) {
        
        if (!checkSession(session)) return "redirect:/login";
        
        com.example.model.Product p = new com.example.model.Product();
        p.setProductCode(productCode);
        p.setName(name);
        p.setCategory(category);
        p.setFlavor(flavor);
        p.setPrice(price);
        p.setStock(stock);
        p.setPcsPerBox(pcsPerBox);
        p.setDescription(description);
        
        productDAO.update(p);
        return "redirect:/manager/products";
    }

    @PostMapping("/products/delete")
    public String deleteProduct(@RequestParam("code") String code, HttpSession session) {
        if (!checkSession(session)) return "redirect:/login";
        productDAO.delete(code);
        return "redirect:/manager/products";
    }

    @PostMapping("/orders/delete")
    public String deleteOrder(@RequestParam("id") int id, HttpSession session) {
        if (!checkSession(session)) return "redirect:/login";
        orderDAO.deleteOrder(id);
        return "redirect:/manager/orders";
    }

    @GetMapping("/orders/items")
    @ResponseBody
    public List<com.example.model.OrderItem> getOrderItems(@RequestParam("id") int id, HttpSession session) {
        if (!checkSession(session)) return null;
        return orderDAO.findOrderItems(id);
    }
}
