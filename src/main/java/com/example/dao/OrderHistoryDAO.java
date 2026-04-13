package com.example.dao;

import com.example.model.OrderHistory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class OrderHistoryDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public void log(int orderId, String action, Integer performedBy, String remarks) {
        String sql = "INSERT INTO order_history (order_id, action, performed_by, remarks) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql, orderId, action, performedBy, remarks);
    }

    public List<OrderHistory> findByOrderId(int orderId) {
        String sql = "SELECT oh.*, s.full_name as performer_name FROM order_history oh " +
                     "LEFT JOIN staff s ON oh.performed_by = s.id " +
                     "WHERE oh.order_id = ? ORDER BY oh.performed_at ASC";
        
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            OrderHistory h = new OrderHistory();
            h.setId(rs.getInt("id"));
            h.setOrderId(rs.getInt("order_id"));
            h.setAction(rs.getString("action"));
            int actorId = rs.getInt("performed_by");
            if (!rs.wasNull()) h.setPerformedBy(actorId);
            h.setPerformedAt(rs.getTimestamp("performed_at"));
            h.setRemarks(rs.getString("remarks"));
            h.setPerformerName(rs.getString("performer_name"));
            return h;
        }, orderId);
    }
}
