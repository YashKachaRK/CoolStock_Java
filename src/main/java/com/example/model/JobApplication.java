package com.example.model;

import java.util.Date;

public class JobApplication {

    private int id;
    private String fullName;
    private String email;
    private String phone;
    private String role;
    private String coverLetter;
    private String status;
    private Date appliedAt;

    // ── Constructors ──────────────────────────────────────────────────────────

    public JobApplication() {}

    public JobApplication(String fullName, String email, String phone,
                          String role, String coverLetter) {
        this.fullName    = fullName;
        this.email       = email;
        this.phone       = phone;
        this.role        = role;
        this.coverLetter = coverLetter;
        this.status      = "PENDING";
    }

    // ── Getters & Setters ─────────────────────────────────────────────────────

    public int getId()                        { return id; }
    public void setId(int id)                 { this.id = id; }

    public String getFullName()               { return fullName; }
    public void setFullName(String fullName)  { this.fullName = fullName; }

    public String getEmail()                  { return email; }
    public void setEmail(String email)        { this.email = email; }

    public String getPhone()                  { return phone; }
    public void setPhone(String phone)        { this.phone = phone; }

    public String getRole()                   { return role; }
    public void setRole(String role)          { this.role = role; }

    public String getCoverLetter()                    { return coverLetter; }
    public void setCoverLetter(String coverLetter)    { this.coverLetter = coverLetter; }

    public String getStatus()                 { return status; }
    public void setStatus(String status)      { this.status = status; }

    public Date getAppliedAt()              { return appliedAt; }
    public void setAppliedAt(Date appliedAt) { this.appliedAt = appliedAt; }

    @Override
    public String toString() {
        return "JobApplication{id=" + id + ", fullName='" + fullName + "', role='" + role + "', status='" + status + "'}";
    }
}
