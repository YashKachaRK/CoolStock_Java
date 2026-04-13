package com.example.model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Order {
    private int id;
    private String orderNumber;
    private int customerId;
    private Integer deliveryBoyId;
    private Date orderDate;
    private BigDecimal totalAmount;
    private String status;
    private String deliveryPriority;
    private String paymentStatus;
    private Integer cashierId;

    // Transient fields for display
    private Customer customer;
    private Staff deliveryBoy;
    private Staff cashier;
    private List<OrderItem> items;
    private String itemsSummary;

    public Order() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getOrderNumber() { return orderNumber; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public Integer getDeliveryBoyId() { return deliveryBoyId; }
    public void setDeliveryBoyId(Integer deliveryBoyId) { this.deliveryBoyId = deliveryBoyId; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDeliveryPriority() { return deliveryPriority; }
    public void setDeliveryPriority(String deliveryPriority) { this.deliveryPriority = deliveryPriority; }

    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }

    public Staff getDeliveryBoy() { return deliveryBoy; }
    public void setDeliveryBoy(Staff deliveryBoy) { this.deliveryBoy = deliveryBoy; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }

    public String getItemsSummary() { return itemsSummary; }
    public void setItemsSummary(String itemsSummary) { this.itemsSummary = itemsSummary; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Integer getCashierId() { return cashierId; }
    public void setCashierId(Integer cashierId) { this.cashierId = cashierId; }

    public Staff getCashier() { return cashier; }
    public void setCashier(Staff cashier) { this.cashier = cashier; }
}
