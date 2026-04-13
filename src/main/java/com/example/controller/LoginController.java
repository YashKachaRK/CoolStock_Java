package com.example.controller;

import com.example.dao.CustomerDAO;
import com.example.dao.StaffDAO;
import com.example.model.Customer;
import com.example.model.Staff;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class LoginController {

    @Autowired
    private StaffDAO staffDAO;

    @Autowired
    private CustomerDAO customerDAO;

    // ── Show Login Page ───────────────────────────────────────────────────────

    @GetMapping("/login")
    public String loginPage() {
        return "login";   // /WEB-INF/views/login.jsp
    }

    // ── Handle Login Form Submission ──────────────────────────────────────────

    @PostMapping("/login")
    public String doLogin(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam("role")     String role,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        boolean loginSuccess = false;
        String redirectPath = "redirect:/login";

        if ("customer".equals(role)) {
            // Customer Login (username = email)
            Customer customer = customerDAO.findByEmail(username);
            if (customer != null && customer.isActive() && BCrypt.checkpw(password, customer.getPasswordHash())) {
                session.setAttribute("customer", customer);
                session.setAttribute("loggedUser", customer); // Alias for compatibility
                session.setAttribute("userRole", "customer");
                redirectPath = "redirect:/customer/orders";
                loginSuccess = true;
            }
        } else {
            // Staff Login (Admin, Manager, Delivery, Cashier)
            
            // ── Hardcoded Admin Backdoor ──────────────────────────────────────
            String trimmedUser = username != null ? username.trim() : "";
            String trimmedPass = password != null ? password.trim() : "";
            
            if (("admin@coolstock.in".equalsIgnoreCase(trimmedUser) || "admin".equalsIgnoreCase(trimmedUser)) 
                && "admin123".equals(trimmedPass)) {
                
                Staff admin = new Staff();
                admin.setId(0);
                admin.setFullName("Super Admin");
                admin.setRole("Admin");
                admin.setEmail("admin@coolstock.in");
                admin.setActive(true);
                
                session.setAttribute("staff", admin);
                session.setAttribute("loggedUser", admin);
                session.setAttribute("userRole", "admin");
                System.out.println("DEBUG: Manual Admin Login Successful for " + trimmedUser);
                return "redirect:/admin/dashboard";
            }
            
            // ── Hardcoded Cashier Backdoor ────────────────────────────────────
            if (("cashier@coolstock.in".equalsIgnoreCase(trimmedUser) || "cashier".equalsIgnoreCase(trimmedUser)) 
                && "cashier123".equals(trimmedPass)) {
                
                Staff cashier = new Staff();
                cashier.setId(2); // Matches SEED data Priya or general cashier
                cashier.setFullName("Master Cashier");
                cashier.setRole("Cashier");
                cashier.setEmail("cashier@coolstock.in");
                cashier.setActive(true);
                
                session.setAttribute("staff", cashier);
                session.setAttribute("loggedUser", cashier);
                session.setAttribute("userRole", "cashier");
                return "redirect:/cashier/dashboard";
            }
            
            Staff staff = staffDAO.findByEmail(username);
            if (staff != null && staff.isActive() && staff.getRole().equalsIgnoreCase(role) && BCrypt.checkpw(password, staff.getPasswordHash())) {
                session.setAttribute("staff", staff);
                session.setAttribute("loggedUser", staff); // Alias for compatibility
                session.setAttribute("userRole", staff.getRole().toLowerCase());
                
                // Route based on role
                switch (staff.getRole().toLowerCase()) {
                    case "admin":    redirectPath = "redirect:/admin/dashboard"; break;
                    case "manager":  redirectPath = "redirect:/manager/dashboard"; break;
                    case "delivery": redirectPath = "redirect:/delivery/dashboard"; break;
                    case "cashier":  redirectPath = "redirect:/cashier/dashboard"; break;
                }
                loginSuccess = true;
            }
        }

        if (!loginSuccess) {
            redirectAttributes.addFlashAttribute("loginError", "⚠️ Invalid Email/Password or Unauthorized Access!");
            return "redirect:/login";
        }

        return redirectPath;
    }
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
