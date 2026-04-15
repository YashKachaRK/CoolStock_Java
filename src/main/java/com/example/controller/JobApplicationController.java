package com.example.controller;

import com.example.model.JobApplication;
import com.example.service.JobApplicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class JobApplicationController {

    @Autowired
    private JobApplicationService jobApplicationService;

    @Autowired
    private com.example.dao.StaffDAO staffDAO;

    @Autowired
    private com.example.service.EmailService emailService;

    // ── Serve home page ───────────────────────────────────────────────────────

    @GetMapping("/")
    public String home() {
        return "index";   // resolves to /WEB-INF/views/index.jsp
    }

    @GetMapping("/checkEmail")
    @ResponseBody
    public String checkEmail(@RequestParam("email") String email) {
        if (jobApplicationService.isEmailRegistered(email)) {
             return "⚠️ This email is already registered. Please use another.";
        }
        return "true";
    }



    // ── Approve a job application ─────────────────────────────────────────────

    @PostMapping("/admin/applications/approve")
    public String approveApplication(
            @RequestParam("id") int id,
            RedirectAttributes redirectAttributes) {
        
        JobApplication app = jobApplicationService.getApplicationById(id);
        if (app != null) {
            // 1. Generate Random Password
            String plainPassword = generateRandomPassword(8);
            String hashedPassword = org.mindrot.jbcrypt.BCrypt.hashpw(plainPassword, org.mindrot.jbcrypt.BCrypt.gensalt());
            
            // 2. Create Staff Account
            com.example.model.Staff newStaff = new com.example.model.Staff();
            newStaff.setFullName(app.getFullName());
            newStaff.setEmail(app.getEmail());
            newStaff.setPhone(app.getPhone());
            newStaff.setRole(app.getRole());
            newStaff.setPasswordHash(hashedPassword);
            newStaff.setStaffKey("STF-" + System.currentTimeMillis());
            newStaff.setActive(true);
            
            staffDAO.save(newStaff);
            
            // 3. Send Credentials via Email
            emailService.sendCredentials(app.getEmail(), app.getRole(), plainPassword);
            
            // 4. Update Application Status
            jobApplicationService.updateStatus(id, "ACCEPTED");
            
            redirectAttributes.addFlashAttribute("toastMsg", "Approved & Credentials Sent to " + app.getEmail());
        }
        
        return "redirect:/admin/dashboard";
    }

    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$";
        java.util.Random rnd = new java.util.Random();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }

    // ── Reject a job application ──────────────────────────────────────────────

    @PostMapping("/admin/applications/reject")
    public String rejectApplication(
            @RequestParam("id") int id,
            RedirectAttributes redirectAttributes) {
        jobApplicationService.updateStatus(id, "REJECTED");
        redirectAttributes.addFlashAttribute("toastMsg", "REJECTED");
        return "redirect:/admin/dashboard";
    }

    // ── Handle Apply Form Submission ──────────────────────────────────────────

    /**
     * POST /apply
     * Receives form fields from the modal form in index.jsp
     */
    @PostMapping("/apply")
    public String submitApplication(
            @RequestParam("full_name")    String fullName,
            @RequestParam("email")        String email,
            @RequestParam("phone")        String phone,
            @RequestParam("role")         String role,
            @RequestParam(value = "cover_letter", required = false, defaultValue = "") String coverLetter,
            RedirectAttributes redirectAttributes) {

        JobApplication app = new JobApplication(fullName, email, phone, role, coverLetter);
        boolean saved = jobApplicationService.submitApplication(app);

        if (saved) {
            redirectAttributes.addFlashAttribute("successMsg",
                    "✅ Thank you, " + fullName + "! Your application for " + role + " has been received.");
        } else {
            redirectAttributes.addFlashAttribute("errorMsg",
                    "❌ Something went wrong. Please try again.");
        }

        return "redirect:/";   // redirect back to home page
    }
}
