package com.example.model;

import java.util.Date;

public class Staff {
    private int id;
    private String staffKey;
    private String fullName;
    private String role;
    private String phone;
    private String email;
    private String passwordHash;
    private boolean isActive;
    private Date joinedDate;

    // We can also have an orders count field for display purposes
    private transient int ordersHandled;

    public Staff() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getStaffKey() { return staffKey; }
    public void setStaffKey(String staffKey) { this.staffKey = staffKey; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public Date getJoinedDate() { return joinedDate; }
    public void setJoinedDate(Date joinedDate) { this.joinedDate = joinedDate; }

    public int getOrdersHandled() { return ordersHandled; }
    public void setOrdersHandled(int ordersHandled) { this.ordersHandled = ordersHandled; }
}
