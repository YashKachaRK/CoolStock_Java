package com.example.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailServiceImpl implements EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Override
    public void sendSimpleMessage(String to, String subject, String text) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("CoolStock <YOUR_GMAIL@gmail.com>");
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            mailSender.send(message);
        } catch (Exception e) {
            System.err.println("Failed to send email to " + to + ": " + e.getMessage());
        }
    }

    @Override
    public void sendJobApplicationConfirmation(String to, String name) {
        String subject = "Job Application Received - CoolStock";
        String text = "Dear " + name + ",\n\n" +
                     "Thank you for applying for a position at CoolStock. We have successfully received your request.\n" +
                     "Our team will review your application and proceed further if your profile matches our requirements.\n\n" +
                     "Best regards,\n" +
                     "CoolStock Management Team";
        sendSimpleMessage(to, subject, text);
    }

    @Override
    public void sendOrderUpdate(String to, String orderNumber, String status) {
        String subject = "Order Update: " + orderNumber + " [" + status + "]";
        String text = "Dear Customer,\n\n" +
                     "Your order " + orderNumber + " status has been updated to: " + status + ".\n\n" +
                     "Thank you for business with CoolStock!\n" +
                     "Best regards,\n" +
                     "CoolStock Team";
        sendSimpleMessage(to, subject, text);
    }

    @Override
    public void sendInventoryAlert(String managerEmail, String productName, String alertType) {
        String subject = "INVENTORY ALERT: " + productName + " [" + alertType + "]";
        String text = "System Alert,\n\n" +
                     "The following product requires attention:\n" +
                     "Product: " + productName + "\n" +
                     "Alert Type: " + alertType + "\n\n" +
                     "Please check the inventory dashboard for details.\n\n" +
                     "Automated Alert System";
        sendSimpleMessage(managerEmail, subject, text);
    }

    @Override
    public void sendOTP(String to, String otp) {
        String subject = "Your Password Reset OTP - CoolStock";
        String text = "Hello,\n\n" +
                     "You have requested to reset your password. Use the following 6-digit One-Time Password (OTP) to proceed:\n\n" +
                     "OTP: " + otp + "\n\n" +
                     "This OTP is valid for 10 minutes. If you did not request this, please ignore this email.\n\n" +
                     "Best regards,\n" +
                     "CoolStock Security Team";
        sendSimpleMessage(to, subject, text);
    }

    @Override
    public void sendCredentials(String to, String role, String password) {
        String subject = "Your CoolStock Account Credentials";
        String text = "Congratulations!\n\n" +
                     "Your job application has been approved. Your account has been created with the following credentials:\n\n" +
                     "Login Email: " + to + "\n" +
                     "Assigned Role: " + role + "\n" +
                     "Temporary Password: " + password + "\n\n" +
                     "Please log in and change your password immediately for security.\n\n" +
                     "Welcome to the team!\n" +
                     "CoolStock management";
        sendSimpleMessage(to, subject, text);
    }
}
