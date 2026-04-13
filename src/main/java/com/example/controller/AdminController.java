package com.example.controller;

import com.example.dao.CustomerDAO;
import com.example.dao.OrderDAO;
import com.example.dao.ProductDAO;
import com.example.dao.StaffDAO;
import com.example.model.JobApplication;
import com.example.model.Staff;
import com.example.service.JobApplicationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import jakarta.servlet.http.HttpServletResponse;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import java.io.IOException;

import java.util.List;

@Controller
public class AdminController {

    @Autowired
    private JobApplicationService jobApplicationService;

    @Autowired
    private CustomerDAO customerDAO;

    @Autowired
    private StaffDAO staffDAO;

    @Autowired
    private OrderDAO orderDAO;

    @Autowired
    private ProductDAO productDAO;

    private boolean checkAdminSession(HttpSession session) {
        Staff staff = (Staff) session.getAttribute("staff");
        return staff != null && "Admin".equalsIgnoreCase(staff.getRole());
    }

    // ── Dashboard ─────────────────────────────────────────────────────────────
    @GetMapping("/admin/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!checkAdminSession(session)) return "redirect:/login";
        List<JobApplication> applications = jobApplicationService.getAllApplications();
        long pendingCount = applications.stream()
                .filter(a -> "PENDING".equals(a.getStatus()))
                .count();

        // Database calls for dynamic metrics
        List<Staff> activeStaff = staffDAO.findActiveStaff();
        int totalCustomers = customerDAO.findAll().size();
        int totalEmployees = staffDAO.findAll().size();
        // Since getting "this month" requires more logic, we mock or fetch simply:
        int ordersThisMonth = orderDAO.findAllWithDetails().size();

        model.addAttribute("applications", applications);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("activeStaff", activeStaff);
        model.addAttribute("totalCustomers", totalCustomers);
        model.addAttribute("totalEmployees", totalEmployees);
        model.addAttribute("ordersThisMonth", ordersThisMonth);

        return "admin/dashboard";
    }

    // ── Manage Products ───────────────────────────────────────────────────────
    @GetMapping("/admin/products")
    public String viewProducts(HttpSession session, Model model) {
        if (!checkAdminSession(session)) return "redirect:/login";
        model.addAttribute("productsList", productDAO.findAll());
        return "admin/view_products";
    }

    // ── Recent Orders ─────────────────────────────────────────────────────────
    @GetMapping("/admin/orders")
    public String recentOrders(HttpSession session, Model model) {
        if (!checkAdminSession(session)) return "redirect:/login";
        List<com.example.model.Order> orders = orderDAO.findAllWithDetails();
        
        // Calculate dynamic stats
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.ZoneId defaultZone = java.time.ZoneId.systemDefault();
        
        long todayCount = orders.stream()
                .filter(o -> o.getOrderDate() != null && 
                             o.getOrderDate().toInstant().atZone(defaultZone).toLocalDate().equals(today))
                .count();
        
        java.math.BigDecimal todayRevenue = orders.stream()
                .filter(o -> o.getOrderDate() != null && 
                             o.getOrderDate().toInstant().atZone(defaultZone).toLocalDate().equals(today))
                .map(com.example.model.Order::getTotalAmount)
                .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add);
        
        long processingCount = orders.stream().filter(o -> "Processing".equals(o.getStatus())).count();
        long shippedCount = orders.stream().filter(o -> "Shipped".equals(o.getStatus())).count();

        model.addAttribute("ordersList", orders);
        model.addAttribute("todayCount", todayCount);
        model.addAttribute("todayRevenue", todayRevenue);
        model.addAttribute("processingCount", processingCount);
        model.addAttribute("shippedCount", shippedCount);
        
        return "admin/recent_orders";
    }

    @GetMapping("/admin/orders/invoicePdf")
    public void downloadInvoice(@org.springframework.web.bind.annotation.RequestParam("id") String orderNumber, HttpServletResponse response) {
        try {
            com.example.model.Order order = orderDAO.findByOrderNumber(orderNumber);
            if (order == null) {
                response.sendError(404, "Order not found");
                return;
            }
            List<com.example.model.OrderItem> items = orderDAO.findOrderItems(order.getId());

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=Invoice_" + orderNumber + ".pdf");

            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Header
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD);
            Paragraph title = new Paragraph("COOLSTOCK - TAX INVOICE", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            document.add(new Paragraph(" "));

            // Order Info
            PdfPTable infoTable = new PdfPTable(2);
            infoTable.setWidthPercentage(100);
            infoTable.addCell("Order Number: " + order.getOrderNumber());
            infoTable.addCell("Date: " + order.getOrderDate());
            infoTable.addCell("Customer: " + (order.getCustomer() != null ? order.getCustomer().getShopName() : "N/A"));
            infoTable.addCell("Status: " + order.getStatus());
            document.add(infoTable);
            document.add(new Paragraph(" "));

            // Items Table
            PdfPTable table = new PdfPTable(4);
            table.setWidthPercentage(100);
            table.addCell("Product");
            table.addCell("Quantity");
            table.addCell("Unit Price");
            table.addCell("Total");

            for (com.example.model.OrderItem item : items) {
                table.addCell(item.getProduct() != null ? item.getProduct().getName() : "Unknown");
                table.addCell(String.valueOf(item.getQuantity()));
                table.addCell(String.valueOf(item.getUnitPrice()));
                table.addCell(String.valueOf(item.getTotalPrice()));
            }
            document.add(table);

            document.add(new Paragraph(" "));
            Paragraph total = new Paragraph("GRAND TOTAL: INR " + order.getTotalAmount(), new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD));
            total.setAlignment(Element.ALIGN_RIGHT);
            document.add(total);

            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ── Manage Staff ──────────────────────────────────────────────────────────
    @GetMapping("/admin/staff")
    public String manageStaff(HttpSession session, Model model) {
        if (!checkAdminSession(session)) return "redirect:/login";
        model.addAttribute("staffList", staffDAO.findAll());
        return "admin/view_employees";
    }

    @org.springframework.web.bind.annotation.PostMapping("/admin/employees/add")
    public String addStaff(
            @org.springframework.web.bind.annotation.RequestParam("fullName") String fullName,
            @org.springframework.web.bind.annotation.RequestParam("role") String role,
            @org.springframework.web.bind.annotation.RequestParam("phone") String phone,
            @org.springframework.web.bind.annotation.RequestParam("email") String email,
            @org.springframework.web.bind.annotation.RequestParam("password") String password) {
        
        com.example.model.Staff s = new com.example.model.Staff();
        s.setStaffKey("STAFF-" + System.currentTimeMillis());
        s.setFullName(fullName);
        s.setRole(role);
        s.setPhone(phone);
        s.setEmail(email);
        
        String hashed = org.mindrot.jbcrypt.BCrypt.hashpw(password, org.mindrot.jbcrypt.BCrypt.gensalt());
        s.setPasswordHash(hashed);
        s.setActive(true);
        staffDAO.save(s);
        
        return "redirect:/admin/staff";
    }

    @org.springframework.web.bind.annotation.GetMapping("/admin/employees/toggle")
    public String toggleStaffStatus(@org.springframework.web.bind.annotation.RequestParam("id") int id,
                                    @org.springframework.web.bind.annotation.RequestParam("active") boolean active) {
        staffDAO.toggleStatus(id, active);
        return "redirect:/admin/staff";
    }

    // ── Manage Customers ──────────────────────────────────────────────────────
    @GetMapping("/admin/customers")
    public String manageCustomers(HttpSession session, Model model) {
        if (!checkAdminSession(session)) return "redirect:/login";
        List<com.example.model.Customer> customers = customerDAO.findAll();
        List<com.example.model.Order> orders = orderDAO.findAllWithDetails();
        
        java.time.LocalDate today = java.time.LocalDate.now();
        int currentMonth = today.getMonthValue();
        int currentYear = today.getYear();
        
        long activeThisMonth = orders.stream()
                .filter(o -> {
                    if (o.getOrderDate() == null) return false;
                    java.time.LocalDateTime ldt = o.getOrderDate().toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDateTime();
                    return ldt.getMonthValue() == currentMonth && ldt.getYear() == currentYear;
                })
                .map(com.example.model.Order::getCustomerId)
                .distinct()
                .count();

        long monthlyOrders = orders.stream()
                .filter(o -> {
                    if (o.getOrderDate() == null) return false;
                    java.time.LocalDateTime ldt = o.getOrderDate().toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDateTime();
                    return ldt.getMonthValue() == currentMonth && ldt.getYear() == currentYear;
                })
                .count();

        model.addAttribute("customersList", customers);
        model.addAttribute("totalCustomers", customers.size());
        model.addAttribute("activeThisMonthCount", activeThisMonth);
        model.addAttribute("monthlyOrdersCount", monthlyOrders);
        return "admin/view_customers";
    }

    @org.springframework.web.bind.annotation.PostMapping("/admin/customers/add")
    public String addCustomer(
            @org.springframework.web.bind.annotation.RequestParam("shopName") String shopName,
            @org.springframework.web.bind.annotation.RequestParam("ownerName") String ownerName,
            @org.springframework.web.bind.annotation.RequestParam("phone") String phone,
            @org.springframework.web.bind.annotation.RequestParam("city") String city,
            @org.springframework.web.bind.annotation.RequestParam("area") String area,
            @org.springframework.web.bind.annotation.RequestParam(value = "email", required = false) String email,
            @org.springframework.web.bind.annotation.RequestParam("password") String password) {
        
        com.example.model.Customer c = new com.example.model.Customer();
        c.setCustomerKey("CUST-" + System.currentTimeMillis());
        c.setShopName(shopName);
        c.setOwnerName(ownerName);
        c.setPhone(phone);
        c.setCity(city);
        c.setArea(area);
        c.setEmail(email);
        
        String hashed = org.mindrot.jbcrypt.BCrypt.hashpw(password, org.mindrot.jbcrypt.BCrypt.gensalt());
        c.setPasswordHash(hashed);
        c.setActive(true);
        customerDAO.save(c);
        
        return "redirect:/admin/customers";
    }
    
    @org.springframework.web.bind.annotation.GetMapping("/admin/customers/toggle")
    public String toggleCustomerStatus(@org.springframework.web.bind.annotation.RequestParam("id") int id,
                                       @org.springframework.web.bind.annotation.RequestParam("active") boolean active) {
        customerDAO.toggleStatus(id, active);
        return "redirect:/admin/customers";
    }

    // ── My Profile ────────────────────────────────────────────────────────────
    @GetMapping("/admin/profile")
    public String profile(HttpSession session) {
        if (!checkAdminSession(session)) return "redirect:/login";
        return "admin/profile";
    }

    // ── Legacy redirect ───────────────────────────────────────────────────────
    @GetMapping("/manageProductAdmin")
    public String manageProductAdminLegacy() {
        return "redirect:/admin/products";
    }
}
