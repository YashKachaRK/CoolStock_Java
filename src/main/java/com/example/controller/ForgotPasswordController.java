package com.example.controller;

import com.example.dao.CustomerDAO;
import com.example.dao.StaffDAO;
import com.example.model.Customer;
import com.example.model.Staff;
import com.example.service.EmailService;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Random;

@Controller
public class ForgotPasswordController {

    @Autowired
    private StaffDAO staffDAO;

    @Autowired
    private CustomerDAO customerDAO;

    @Autowired
    private EmailService emailService;

    @GetMapping("/forgot-password")
    public String showForgotPassword() {
        return "forgot_password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email, HttpSession session, Model model) {
        // 1. Find user in Staff or Customer tables
        Staff staff = staffDAO.findByEmail(email);
        Customer customer = (staff == null) ? customerDAO.findByEmail(email) : null;

        if (staff == null && customer == null) {
            model.addAttribute("error", "⚠️ Email address not found in our records.");
            return "forgot_password";
        }

        // 2. Generate 6-digit OTP
        String otp = String.format("%06d", new Random().nextInt(999999));
        
        // 3. Store in session
        session.setAttribute("resetEmail", email);
        session.setAttribute("otp", otp);
        session.setAttribute("userType", (staff != null) ? "staff" : "customer");
        session.setAttribute("userId", (staff != null) ? staff.getId() : customer.getId());

        // 4. Send Email
        emailService.sendOTP(email, otp);

        return "redirect:/verify-otp";
    }

    @GetMapping("/verify-otp")
    public String showVerifyOtp(HttpSession session) {
        if (session.getAttribute("otp") == null) return "redirect:/forgot-password";
        return "verify_otp";
    }

    @PostMapping("/verify-otp")
    public String processVerifyOtp(@RequestParam("otp") String enteredOtp, HttpSession session, Model model) {
        String actualOtp = (String) session.getAttribute("otp");

        if (actualOtp != null && actualOtp.equals(enteredOtp)) {
            session.setAttribute("otpVerified", true);
            return "redirect:/reset-password";
        } else {
            model.addAttribute("error", "⚠️ Invalid OTP. Please try again.");
            return "verify_otp";
        }
    }

    @GetMapping("/reset-password")
    public String showResetPassword(HttpSession session) {
        Boolean verified = (Boolean) session.getAttribute("otpVerified");
        if (verified == null || !verified) return "redirect:/forgot-password";
        return "reset_password";
    }

    @PostMapping("/reset-password")
    public String processResetPassword(
            @RequestParam("password") String password,
            @RequestParam("confirmPassword") String confirmPassword,
            HttpSession session,
            Model model) {
        
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "⚠️ Passwords do not match.");
            return "reset_password";
        }

        String email = (String) session.getAttribute("resetEmail");
        String userType = (String) session.getAttribute("userType");
        Integer userId = (Integer) session.getAttribute("userId");

        if (email == null || userType == null || userId == null) {
            return "redirect:/forgot-password";
        }

        // Hash and Update
        String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
        
        if ("staff".equals(userType)) {
            staffDAO.updatePassword(userId, hashed);
        } else {
            customerDAO.updatePassword(userId, hashed);
        }

        // Clean up session
        session.removeAttribute("otp");
        session.removeAttribute("otpVerified");
        session.removeAttribute("resetEmail");
        session.removeAttribute("userType");
        session.removeAttribute("userId");

        return "redirect:/login?msg=Password updated successfully!";
    }
}
