package com.example.model;

import java.sql.Timestamp;

public class OrderHistory {
    private int id;
    private int orderId;
    private String action;
    private Integer performedBy;
    private Timestamp performedAt;
    private String remarks;

    // Transient field for display
    private String performerName;

    public OrderHistory() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public Integer getPerformedBy() { return performedBy; }
    public void setPerformedBy(Integer performedBy) { this.performedBy = performedBy; }

    public Timestamp getPerformedAt() { return performedAt; }
    public void setPerformedAt(Timestamp performedAt) { this.performedAt = performedAt; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public String getPerformerName() { return performerName; }
    public void setPerformerName(String performerName) { this.performerName = performerName; }
}
