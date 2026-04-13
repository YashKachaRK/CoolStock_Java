package com.example.controller;

import com.example.dao.OrderDAO;
import com.example.model.Staff;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/cashier")
public class CashierController {

    @Autowired
    private OrderDAO orderDAO;

    private boolean checkSession(HttpSession session) {
        Staff staff = (Staff) session.getAttribute("staff");
        return staff != null && "Cashier".equalsIgnoreCase(staff.getRole());
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!checkSession(session)) return "redirect:/login";
        
        Staff staff = (Staff) session.getAttribute("staff");
        int cashierId = staff.getId();
        
        model.addAttribute("pendingPayments", orderDAO.findPendingDepositsForCashier(cashierId));
        model.addAttribute("verifiedToday", orderDAO.findPaidTodayForCashier(cashierId));
        
        model.addAttribute("countPending", orderDAO.findPendingDepositsForCashier(cashierId).size());
        model.addAttribute("countVerified", orderDAO.findPaidTodayForCashier(cashierId).size());
        model.addAttribute("totalCashToday", orderDAO.sumPaidTodayForCashier(cashierId));
        
        return "cashier/dashboard";
    }

    @PostMapping("/verifyPayment")
    public String verifyPayment(@RequestParam("orderId") int orderId, HttpSession session) {
        if (!checkSession(session)) return "redirect:/login";
        orderDAO.confirmPayment(orderId);
        return "redirect:/cashier/dashboard";
    }
}
