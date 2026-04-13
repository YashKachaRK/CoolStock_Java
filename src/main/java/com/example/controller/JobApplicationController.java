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

    // ── Serve home page ───────────────────────────────────────────────────────

    @GetMapping("/")
    public String home() {
        return "index";   // resolves to /WEB-INF/views/index.jsp
    }



    // ── Approve a job application ─────────────────────────────────────────────

    @PostMapping("/admin/applications/approve")
    public String approveApplication(
            @RequestParam("id") int id,
            RedirectAttributes redirectAttributes) {
        jobApplicationService.updateStatus(id, "ACCEPTED");
        redirectAttributes.addFlashAttribute("toastMsg", "ACCEPTED");
        return "redirect:/admin/dashboard";
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
