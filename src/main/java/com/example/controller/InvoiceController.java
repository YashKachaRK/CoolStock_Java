package com.example.controller;

import com.example.dao.OrderDAO;
import com.example.model.Order;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class InvoiceController {

    @Autowired
    private OrderDAO orderDAO;

    @GetMapping("/invoice/print")
    public String printInvoice(@RequestParam("orderId") int orderId, HttpSession session, Model model) {
        // Simple security check: Ensure user is logged in
        if (session.getAttribute("loggedUser") == null && session.getAttribute("staff") == null) {
            return "redirect:/login";
        }

        Order order = orderDAO.findById(orderId);
        if (order == null) return "error/404";
        
        // Fetch detailed items for the invoice
        order.setItems(orderDAO.findOrderItems(orderId));
        
        model.addAttribute("order", order);
        return "common/invoice_print";
    }
}
