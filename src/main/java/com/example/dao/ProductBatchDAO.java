package com.example.dao;

import com.example.model.ProductBatch;
import com.example.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class ProductBatchDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private EmailService emailService;

    public void addBatch(ProductBatch batch) {
        String sql = "INSERT INTO product_batches (product_id, batch_number, quantity, expiry_date) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql, batch.getProductId(), batch.getBatchNumber(), batch.getQuantity(), batch.getExpiryDate());
    }

    public List<ProductBatch> findByProductId(int productId) {
        String sql = "SELECT * FROM product_batches WHERE product_id = ? AND quantity > 0 ORDER BY expiry_date ASC, received_at ASC";
        return jdbcTemplate.query(sql, new ProductBatchRowMapper(), productId);
    }

    public List<ProductBatch> findExpiringSoon(int daysThreshold) {
        String sql = "SELECT * FROM product_batches WHERE quantity > 0 AND expiry_date <= DATE_ADD(CURDATE(), INTERVAL ? DAY) ORDER BY expiry_date ASC";
        return jdbcTemplate.query(sql, new ProductBatchRowMapper(), daysThreshold);
    }

    public int countExpiringSoon(int daysThreshold) {
        String sql = "SELECT COUNT(*) FROM product_batches WHERE quantity > 0 AND expiry_date <= DATE_ADD(CURDATE(), INTERVAL ? DAY)";
        return jdbcTemplate.queryForObject(sql, Integer.class, daysThreshold);
    }

    @Transactional
    public void consumeStockFEFO(int productId, int quantityToConsume) {
        List<ProductBatch> batches = findByProductId(productId);
        int remaining = quantityToConsume;

        for (ProductBatch batch : batches) {
            if (remaining <= 0) break;

            int consumeFromThisBatch = Math.min(batch.getQuantity(), remaining);
            String sql = "UPDATE product_batches SET quantity = quantity - ? WHERE id = ?";
            jdbcTemplate.update(sql, consumeFromThisBatch, batch.getId());
            
            remaining -= consumeFromThisBatch;
        }

        if (remaining > 0) {
            throw new RuntimeException("Insufficient stock in batches for product ID: " + productId);
        }
    }

    @Transactional
    public void processExpiryAlerts(int daysThreshold, String managerEmail) {
        String query = "SELECT pb.*, p.name as product_name FROM product_batches pb " +
                      "JOIN products p ON pb.product_id = p.id " +
                      "WHERE pb.quantity > 0 AND pb.expiry_alert_sent = FALSE " +
                      "AND pb.expiry_date <= DATE_ADD(CURDATE(), INTERVAL ? DAY)";
        
        jdbcTemplate.query(query, (rs) -> {
            String prodName = rs.getString("product_name");
            String expiry = rs.getString("expiry_date");
            emailService.sendInventoryAlert(managerEmail, prodName, "Expiry (" + expiry + ")");
            jdbcTemplate.update("UPDATE product_batches SET expiry_alert_sent = TRUE WHERE id = ?", rs.getInt("id"));
        }, daysThreshold);
    }

    private static class ProductBatchRowMapper implements RowMapper<ProductBatch> {
        @Override
        public ProductBatch mapRow(ResultSet rs, int rowNum) throws SQLException {
            ProductBatch b = new ProductBatch();
            b.setId(rs.getInt("id"));
            b.setProductId(rs.getInt("product_id"));
            b.setBatchNumber(rs.getString("batch_number"));
            b.setQuantity(rs.getInt("quantity"));
            b.setExpiryDate(rs.getDate("expiry_date"));
            b.setReceivedAt(rs.getTimestamp("received_at"));
            return b;
        }
    }
}
