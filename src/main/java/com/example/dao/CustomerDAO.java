package com.example.dao;

import com.example.model.Customer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class CustomerDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Customer> findAll() {
        String sql = "SELECT * FROM customers ORDER BY joined_date DESC";
        return jdbcTemplate.query(sql, new CustomerRowMapper());
    }

    public Customer findById(int id) {
        String sql = "SELECT * FROM customers WHERE id = ?";
        List<Customer> list = jdbcTemplate.query(sql, new CustomerRowMapper(), id);
        return list.isEmpty() ? null : list.get(0);
    }
    
    public int toggleStatus(int id, boolean status) {
        String sql = "UPDATE customers SET is_active = ? WHERE id = ?";
        return jdbcTemplate.update(sql, status, id);
    }

    public Customer findByEmail(String email) {
        String sql = "SELECT * FROM customers WHERE email = ?";
        List<Customer> list = jdbcTemplate.query(sql, new CustomerRowMapper(), email);
        return list.isEmpty() ? null : list.get(0);
    }

    public int save(Customer customer) {
        String sql = "INSERT INTO customers (customer_key, shop_name, owner_name, phone, email, city, area, password_hash, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                customer.getCustomerKey(),
                customer.getShopName(),
                customer.getOwnerName(),
                customer.getPhone(),
                customer.getEmail(),
                customer.getCity(),
                customer.getArea(),
                customer.getPasswordHash(),
                customer.isActive());
    }

    public int updatePassword(int id, String newPasswordHash) {
        String sql = "UPDATE customers SET password_hash = ? WHERE id = ?";
        return jdbcTemplate.update(sql, newPasswordHash, id);
    }

    public int incrementTotalSpend(int id, java.math.BigDecimal amount) {
        String sql = "UPDATE customers SET total_spend = total_spend + ? WHERE id = ?";
        return jdbcTemplate.update(sql, amount, id);
    }

    private static class CustomerRowMapper implements RowMapper<Customer> {
        @Override
        public Customer mapRow(ResultSet rs, int rowNum) throws SQLException {
            Customer c = new Customer();
            c.setId(rs.getInt("id"));
            c.setCustomerKey(rs.getString("customer_key"));
            c.setShopName(rs.getString("shop_name"));
            c.setOwnerName(rs.getString("owner_name"));
            c.setPhone(rs.getString("phone"));
            c.setEmail(rs.getString("email"));
            c.setCity(rs.getString("city"));
            c.setArea(rs.getString("area"));
            c.setPasswordHash(rs.getString("password_hash"));
            c.setActive(rs.getBoolean("is_active"));
            c.setJoinedDate(rs.getTimestamp("joined_date"));
            c.setTotalSpend(rs.getBigDecimal("total_spend"));
            return c;
        }
    }
}
