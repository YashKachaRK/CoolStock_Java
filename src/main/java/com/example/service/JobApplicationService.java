package com.example.service;

import com.example.dao.JobApplicationDAO;
import com.example.model.JobApplication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class JobApplicationService {

    @Autowired
    private JobApplicationDAO jobApplicationDAO;

    @Autowired
    private EmailService emailService;

    public boolean isEmailRegistered(String email) {
        return jobApplicationDAO.existsByEmail(email);
    }

    /**
     * Save a new job application submitted from the website form.
     */
    public boolean submitApplication(JobApplication app) {
        try {
            int rows = jobApplicationDAO.save(app);
            if (rows > 0) {
                // Send confirmation email
                emailService.sendJobApplicationConfirmation(app.getEmail(), app.getFullName());
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieve all applications (admin use).
     */
    public List<JobApplication> getAllApplications() {
        return jobApplicationDAO.findAll();
    }

    /**
     * Get a single application by id.
     */
    public JobApplication getApplicationById(int id) {
        return jobApplicationDAO.findById(id);
    }

    /**
     * Update the review status of an application.
     * @param status  PENDING | REVIEWED | ACCEPTED | REJECTED
     */
    public boolean updateStatus(int id, String status) {
        int rows = jobApplicationDAO.updateStatus(id, status);
        return rows > 0;
    }

    /**
     * Delete an application record.
     */
    public boolean deleteApplication(int id) {
        int rows = jobApplicationDAO.delete(id);
        return rows > 0;
    }
}
