package com.example.service;

public interface EmailService {
    void sendSimpleMessage(String to, String subject, String text);
    void sendJobApplicationConfirmation(String to, String name);
    void sendOrderUpdate(String to, String orderNumber, String status);
    void sendInventoryAlert(String managerEmail, String productName, String alertType);
    void sendOTP(String to, String otp);
    void sendCredentials(String to, String role, String password);
}
