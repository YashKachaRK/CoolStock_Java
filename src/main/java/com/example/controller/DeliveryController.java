package com.example.controller;

import com.example.dao.OrderDAO;
import com.example.dao.StaffDAO;
import com.example.model.Staff;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/delivery")
public class DeliveryController {

    @Autowired
    private OrderDAO orderDAO;

    @Autowired
    private StaffDAO staffDAO;

    private boolean checkSession(HttpSession session) {
        Staff staff = (Staff) session.getAttribute("staff");
        return staff != null && "Delivery".equalsIgnoreCase(staff.getRole());
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!checkSession(session)) return "redirect:/login";
        Staff staff = (Staff) session.getAttribute("staff");
        int staffId = staff.getId();
        
        List<Staff> cashiers = staffDAO.findByRole("Cashier");
        model.addAttribute("cashiers", cashiers);
        
        // Show only active tasks (Shipped, In Transit)
        model.addAttribute("assignedOrders", orderDAO.findActiveOrdersByDeliveryBoy(staffId));
        
        model.addAttribute("countAssigned", orderDAO.countOrdersByDeliveryBoyAndStatus(staffId, "Shipped") + 
                                             orderDAO.countOrdersByDeliveryBoyAndStatus(staffId, "In Transit"));
        model.addAttribute("countDelivered", orderDAO.countOrdersByDeliveryBoyAndStatus(staffId, "Delivered"));
        
        return "delivery/dashboard";
    }

    @GetMapping("/history")
    public String history(HttpSession session, Model model) {
        if (!checkSession(session)) return "redirect:/login";
        Staff staff = (Staff) session.getAttribute("staff");
        
        // Show ALL history
        model.addAttribute("historyOrders", orderDAO.findOrdersByDeliveryBoy(staff.getId()));
        return "delivery/history";
    }
    
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        if (!checkSession(session)) return "redirect:/login";
        Staff staff = (Staff) session.getAttribute("staff");
        
        // Refresh staff info from DB
        Staff dbStaff = staffDAO.findById(staff.getId());
        model.addAttribute("staff", dbStaff);
        
        // Contextual metrics
        model.addAttribute("totalDelivered", orderDAO.countOrdersByDeliveryBoyAndStatus(staff.getId(), "Delivered"));
        model.addAttribute("pendingDeposit", orderDAO.countOrdersByDeliveryBoyAndStatus(staff.getId(), "Pending Deposit"));
        
        return "delivery/profile";
    }

    @PostMapping("/updatePassword")
    public String updatePassword(@RequestParam("newPassword") String newPassword,
                                @RequestParam("confirmPassword") String confirmPassword,
                                HttpSession session, 
                                org.springframework.web.servlet.mvc.support.RedirectAttributes ra) {
        if (!checkSession(session)) return "redirect:/login";
        Staff staff = (Staff) session.getAttribute("staff");

        if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("error", "Passwords do not match!");
            return "redirect:/delivery/profile";
        }

        String hashed = org.mindrot.jbcrypt.BCrypt.hashpw(newPassword, org.mindrot.jbcrypt.BCrypt.gensalt());
        staffDAO.updatePassword(staff.getId(), hashed);
        
        ra.addFlashAttribute("success", "Security credentials updated successfully!");
        return "redirect:/delivery/profile";
    }

    @PostMapping("/updateStatus")
    public String updateStatus(@RequestParam("orderId") int orderId, 
                               @RequestParam("status") String status, 
                               @RequestParam(value = "cashierId", required = false) Integer cashierId,
                               HttpSession session) {
        if (!checkSession(session)) return "redirect:/login";
        
        Staff deliveryBoy = (Staff) session.getAttribute("staff");
        if ("Delivered".equalsIgnoreCase(status) && cashierId != null) {
            orderDAO.updateHandover(orderId, "Delivered", "Pending Deposit", cashierId, deliveryBoy.getId());
        } else {
            orderDAO.updateStatusWithLog(orderId, status, deliveryBoy.getId());
        }
        
        return "redirect:/delivery/dashboard";
    }
}
