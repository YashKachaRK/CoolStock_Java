package com.example.model;

import java.math.BigDecimal;
import java.util.Date;

public class Product {
    private int id;
    private String productCode;
    private String name;
    private String category;
    private String flavor;
    private BigDecimal price;
    private int stock;
    private int pcsPerBox;
    private String description;
    private boolean active;
    private Date createdAt;

    public Product() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getFlavor() { return flavor; }
    public void setFlavor(String flavor) { this.flavor = flavor; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public int getPcsPerBox() { return pcsPerBox; }
    public void setPcsPerBox(int pcsPerBox) { this.pcsPerBox = pcsPerBox; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
