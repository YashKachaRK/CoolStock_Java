package com.example.dao;

import com.example.model.Customer;
import com.example.model.Order;
import com.example.model.Staff;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class OrderDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private CustomerDAO customerDAO;

    @Autowired
    private StaffDAO staffDAO;

    @Autowired
    private ProductDAO productDAO;

    @Autowired
    private OrderHistoryDAO orderHistoryDAO;

    public Order findById(int id) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        List<Order> orders = jdbcTemplate.query(sql, new OrderRowMapper(), id);
        if (orders.isEmpty()) return null;
        Order order = orders.get(0);
        order.setCustomer(customerDAO.findById(order.getCustomerId()));
        if (order.getDeliveryBoyId() != null && order.getDeliveryBoyId() > 0) {
            order.setDeliveryBoy(staffDAO.findById(order.getDeliveryBoyId()));
        }
        return order;
    }

    public List<Order> findAllWithDetails() {
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";
        List<Order> orders = jdbcTemplate.query(sql, new OrderRowMapper());
        
        for (Order order : orders) {
            order.setCustomer(customerDAO.findById(order.getCustomerId()));
            if (order.getDeliveryBoyId() != null && order.getDeliveryBoyId() > 0) {
                order.setDeliveryBoy(staffDAO.findById(order.getDeliveryBoyId()));
            }
            order.setItemsSummary(getItemsSummaryForOrder(order.getId()));
        }
        return orders;
    }

    public List<Order> findAllByCustomerId(int customerId) {
        // Sort: Processing/Shipped first, then Delivered/Paid, then Cancelled
        String sql = "SELECT * FROM orders WHERE customer_id = ? " +
                     "ORDER BY CASE " +
                     "  WHEN status = 'Processing' THEN 1 " +
                     "  WHEN status = 'Shipped' THEN 2 " +
                     "  WHEN status = 'In Transit' THEN 3 " +
                     "  WHEN status = 'Delivered' THEN 4 " +
                     "  WHEN status = 'Cancelled' THEN 5 " +
                     "  ELSE 6 END ASC, order_date DESC";
        List<Order> orders = jdbcTemplate.query(sql, new OrderRowMapper(), customerId);
        for (Order order : orders) {
            if (order.getDeliveryBoyId() != null) {
                order.setDeliveryBoy(staffDAO.findById(order.getDeliveryBoyId()));
            }
            order.setItemsSummary(getItemsSummaryForOrder(order.getId()));
        }
        return orders;
    }

    public int cancelOrder(int orderId) {
        // Restore stock before cancelling
        List<com.example.model.OrderItem> items = findOrderItems(orderId);
        for (com.example.model.OrderItem item : items) {
            productDAO.addStock(item.getProductId(), item.getQuantity());
        }
        String sql = "UPDATE orders SET status = 'Cancelled' WHERE id = ?";
        return jdbcTemplate.update(sql, orderId);
    }

    public void saveOrderWithItems(Order order, List<com.example.model.OrderItem> items) {
        String orderSql = "INSERT INTO orders (order_number, customer_id, total_amount, status, delivery_priority) VALUES (?, ?, ?, ?, ?)";
        
        // Using KeyHolder to get generated ID
        org.springframework.jdbc.support.KeyHolder keyHolder = new org.springframework.jdbc.support.GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            java.sql.PreparedStatement ps = connection.prepareStatement(orderSql, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, order.getOrderNumber());
            ps.setInt(2, order.getCustomerId());
            ps.setBigDecimal(3, order.getTotalAmount());
            ps.setString(4, order.getStatus());
            ps.setString(5, order.getDeliveryPriority());
            return ps;
        }, keyHolder);

        int orderId = keyHolder.getKey().intValue();

        String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?)";
        for (com.example.model.OrderItem item : items) {
            jdbcTemplate.update(itemSql, orderId, item.getProductId(), item.getQuantity(), item.getUnitPrice(), item.getTotalPrice());
        }

        // Log initial creation
        orderHistoryDAO.log(orderId, "Ordered", null, "Order placed by customer.");
    }

    private String getItemsSummaryForOrder(int orderId) {
        String sql = "SELECT p.name, oi.quantity FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?";
        List<String> items = jdbcTemplate.query(sql, (rs, rowNum) -> rs.getInt("quantity") + " x " + rs.getString("name"), orderId);
        return String.join(", ", items);
    }

    public Order findByOrderNumber(String orderNumber) {
        String sql = "SELECT * FROM orders WHERE order_number = ?";
        List<Order> orders = jdbcTemplate.query(sql, new OrderRowMapper(), orderNumber);
        if (orders.isEmpty()) return null;
        Order order = orders.get(0);
        order.setCustomer(customerDAO.findById(order.getCustomerId()));
        if (order.getDeliveryBoyId() != null && order.getDeliveryBoyId() > 0) {
            order.setDeliveryBoy(staffDAO.findById(order.getDeliveryBoyId()));
        }
        return order;
    }

    public List<com.example.model.OrderItem> findOrderItems(int orderId) {
        String sql = "SELECT oi.*, p.name as product_name, p.product_code FROM order_items oi " +
                     "JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            com.example.model.OrderItem item = new com.example.model.OrderItem();
            item.setId(rs.getInt("id"));
            item.setOrderId(rs.getInt("order_id"));
            item.setProductId(rs.getInt("product_id"));
            item.setQuantity(rs.getInt("quantity"));
            item.setUnitPrice(rs.getBigDecimal("unit_price"));
            item.setTotalPrice(rs.getBigDecimal("total_price"));
            
            com.example.model.Product p = new com.example.model.Product();
            p.setId(rs.getInt("product_id"));
            p.setName(rs.getString("product_name"));
            p.setProductCode(rs.getString("product_code"));
            item.setProduct(p);
            
            return item;
        }, orderId);
    }

    public int assignDeliveryBoy(int orderId, int staffId, int managerId) {
        String sql = "UPDATE orders SET delivery_boy_id = ?, status = 'Shipped' WHERE id = ?";
        int rows = jdbcTemplate.update(sql, staffId, orderId);
        if (rows > 0) {
            Staff deliveryBoy = staffDAO.findById(staffId);
            orderHistoryDAO.log(orderId, "Assigned", managerId, "Assigned to " + (deliveryBoy != null ? deliveryBoy.getFullName() : "Delivery Boy " + staffId));
        }
        return rows;
    }

    public int updateStatusWithLog(int orderId, String status, Integer performerId) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        int rows = jdbcTemplate.update(sql, status, orderId);
        if (rows > 0) {
            orderHistoryDAO.log(orderId, status, performerId, "Status updated to " + status);
        }
        return rows;
    }

    public int updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        return jdbcTemplate.update(sql, status, orderId);
    }

    public int deleteOrder(int orderId) {
        String sql = "DELETE FROM orders WHERE id = ?";
        return jdbcTemplate.update(sql, orderId);
    }

    public int countOrdersByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, status);
    }

    public int countUrgentOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE delivery_priority IN ('Urgent', 'Very Urgent') AND status != 'Delivered' AND status != 'Cancelled'";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }

    public int countOrdersToday() {
        String sql = "SELECT COUNT(*) FROM orders WHERE DATE(order_date) = CURDATE()";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }

    public java.math.BigDecimal getTotalRevenue() {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE status = 'Delivered'";
        java.math.BigDecimal rev = jdbcTemplate.queryForObject(sql, java.math.BigDecimal.class);
        return rev != null ? rev : java.math.BigDecimal.ZERO;
    }

    public int countTotalDelivered() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'Delivered'";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }

    public List<Order> findProcessingOrders() {
        String sql = "SELECT * FROM orders WHERE status = 'Processing' ORDER BY order_date ASC";
        List<Order> orders = jdbcTemplate.query(sql, new OrderRowMapper());
        for (Order order : orders) {
            order.setCustomer(customerDAO.findById(order.getCustomerId()));
            order.setItemsSummary(getItemsSummaryForOrder(order.getId()));
        }
        return orders;
    }

    public List<Order> findAssignedOrders() {
        String sql = "SELECT * FROM orders WHERE status = 'Shipped' ORDER BY order_date DESC";
        List<Order> orders = jdbcTemplate.query(sql, new OrderRowMapper());
        for (Order order : orders) {
            order.setCustomer(customerDAO.findById(order.getCustomerId()));
            if (order.getDeliveryBoyId() != null) {
                order.setDeliveryBoy(staffDAO.findById(order.getDeliveryBoyId()));
            }
            order.setItemsSummary(getItemsSummaryForOrder(order.getId()));
        }
        return orders;
    }

    public List<Order> findOrdersByDeliveryBoy(int deliveryBoyId) {
        String sql = "SELECT * FROM orders WHERE delivery_boy_id = ? AND status != 'Cancelled' ORDER BY status DESC, order_date DESC";
        List<Order> orders = jdbcTemplate.query(sql, new OrderRowMapper(), deliveryBoyId);
        for (Order order : orders) {
            order.setCustomer(customerDAO.findById(order.getCustomerId()));
            order.setItems(findOrderItems(order.getId()));
            order.setItemsSummary(getItemsSummaryForOrder(order.getId()));
        }
        return orders;
    }

    public int updateStatusAndPayment(int orderId, String status, String paymentStatus) {
        String sql = "UPDATE orders SET status = ?, payment_status = ? WHERE id = ?";
        return jdbcTemplate.update(sql, status, paymentStatus, orderId);
    }

    public int countOrdersByDeliveryBoyAndStatus(int deliveryBoyId, String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE delivery_boy_id = ? AND status = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, deliveryBoyId, status);
    }

    public List<Order> findActiveOrdersByDeliveryBoy(int deliveryBoyId) {
        String sql = "SELECT * FROM orders WHERE delivery_boy_id = ? AND status IN ('Shipped', 'In Transit') ORDER BY order_date DESC";
        List<Order> orders = jdbcTemplate.query(sql, new OrderRowMapper(), deliveryBoyId);
        for (Order order : orders) {
            order.setCustomer(customerDAO.findById(order.getCustomerId()));
            order.setItemsSummary(getItemsSummaryForOrder(order.getId()));
        }
        return orders;
    }

    public int updateHandover(int orderId, String status, String paymentStatus, int cashierId, int deliveryBoyId) {
        String sql = "UPDATE orders SET status = ?, payment_status = ?, cashier_id = ? WHERE id = ?";
        int rows = jdbcTemplate.update(sql, status, paymentStatus, cashierId, orderId);
        if (rows > 0) {
            orderHistoryDAO.log(orderId, "Deposited", deliveryBoyId, "Cash deposited to cashier (ID: " + cashierId + ")");
        }
        return rows;
    }

    public List<Order> findPendingDepositsForCashier(int cashierId) {
        String sql = "SELECT * FROM orders WHERE payment_status = 'Pending Deposit' AND cashier_id = ? ORDER BY order_date DESC";
        List<Order> orders = jdbcTemplate.query(sql, new OrderRowMapper(), cashierId);
        for (Order order : orders) {
            order.setCustomer(customerDAO.findById(order.getCustomerId()));
            if (order.getDeliveryBoyId() != null) {
                order.setDeliveryBoy(staffDAO.findById(order.getDeliveryBoyId()));
            }
            order.setItemsSummary(getItemsSummaryForOrder(order.getId()));
        }
        return orders;
    }

    public List<Order> findPaidTodayForCashier(int cashierId) {
        String sql = "SELECT * FROM orders WHERE payment_status = 'Paid' AND cashier_id = ? AND DATE(order_date) = CURDATE() ORDER BY order_date DESC";
        List<Order> orders = jdbcTemplate.query(sql, new OrderRowMapper(), cashierId);
        for (Order order : orders) {
            order.setCustomer(customerDAO.findById(order.getCustomerId()));
            order.setItemsSummary(getItemsSummaryForOrder(order.getId()));
        }
        return orders;
    }

    public java.math.BigDecimal sumPaidTodayForCashier(int cashierId) {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE payment_status = 'Paid' AND cashier_id = ? AND DATE(order_date) = CURDATE()";
        java.math.BigDecimal sum = jdbcTemplate.queryForObject(sql, java.math.BigDecimal.class, cashierId);
        return sum != null ? sum : java.math.BigDecimal.ZERO;
    }

    public int confirmPayment(int orderId, int cashierId) {
        // Fetch order to get total amount and customerId before confirming
        Order order = findById(orderId);
        if (order != null && "Pending Deposit".equals(order.getPaymentStatus())) {
            customerDAO.incrementTotalSpend(order.getCustomerId(), order.getTotalAmount());
        }
        String sql = "UPDATE orders SET payment_status = 'Paid', status = 'Delivered' WHERE id = ?";
        int rows = jdbcTemplate.update(sql, orderId);
        if (rows > 0) {
            orderHistoryDAO.log(orderId, "Paid", cashierId, "Payment verified and order finalized.");
        }
        return rows;
    }

    private static class OrderRowMapper implements RowMapper<Order> {
        @Override
        public Order mapRow(ResultSet rs, int rowNum) throws SQLException {
            Order o = new Order();
            o.setId(rs.getInt("id"));
            o.setOrderNumber(rs.getString("order_number"));
            o.setCustomerId(rs.getInt("customer_id"));
            int deliveryBoyId = rs.getInt("delivery_boy_id");
            if (!rs.wasNull()) {
                o.setDeliveryBoyId(deliveryBoyId);
            }
            o.setOrderDate(rs.getTimestamp("order_date"));
            o.setTotalAmount(rs.getBigDecimal("total_amount"));
            o.setStatus(rs.getString("status"));
            o.setDeliveryPriority(rs.getString("delivery_priority"));
            o.setPaymentStatus(rs.getString("payment_status"));
            int cashierId = rs.getInt("cashier_id");
            if (!rs.wasNull()) {
                o.setCashierId(cashierId);
            }
            return o;
        }
    }
}
