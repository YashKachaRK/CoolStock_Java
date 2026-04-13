package com.example.dao;

import com.example.model.Staff;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class StaffDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Staff> findAll() {
        String sql = "SELECT * FROM staff ORDER BY joined_date DESC";
        return jdbcTemplate.query(sql, new StaffRowMapper());
    }

    public List<Staff> findActiveStaff() {
        String sql = "SELECT * FROM staff WHERE is_active = true ORDER BY role ASC";
        return jdbcTemplate.query(sql, new StaffRowMapper());
    }

    public Staff findById(int id) {
        String sql = "SELECT * FROM staff WHERE id = ?";
        List<Staff> list = jdbcTemplate.query(sql, new StaffRowMapper(), id);
        return list.isEmpty() ? null : list.get(0);
    }

    public int save(Staff staff) {
        String sql = "INSERT INTO staff (staff_key, full_name, role, phone, email, password_hash, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                staff.getStaffKey(),
                staff.getFullName(),
                staff.getRole(),
                staff.getPhone(),
                staff.getEmail(),
                staff.getPasswordHash(),
                staff.isActive());
    }

    public int toggleStatus(int id, boolean active) {
        String sql = "UPDATE staff SET is_active = ? WHERE id = ?";
        return jdbcTemplate.update(sql, active, id);
    }

    public Staff findByEmail(String email) {
        String sql = "SELECT * FROM staff WHERE email = ?";
        List<Staff> list = jdbcTemplate.query(sql, new StaffRowMapper(), email);
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Staff> findByRole(String role) {
        String sql = "SELECT * FROM staff WHERE role = ? AND is_active = true";
        return jdbcTemplate.query(sql, new StaffRowMapper(), role);
    }

    public int updatePassword(int id, String newPasswordHash) {
        String sql = "UPDATE staff SET password_hash = ? WHERE id = ?";
        return jdbcTemplate.update(sql, newPasswordHash, id);
    }

    private static class StaffRowMapper implements RowMapper<Staff> {
        @Override
        public Staff mapRow(ResultSet rs, int rowNum) throws SQLException {
            Staff s = new Staff();
            s.setId(rs.getInt("id"));
            s.setStaffKey(rs.getString("staff_key"));
            s.setFullName(rs.getString("full_name"));
            s.setRole(rs.getString("role"));
            s.setPhone(rs.getString("phone"));
            s.setEmail(rs.getString("email"));
            s.setPasswordHash(rs.getString("password_hash"));
            s.setActive(rs.getBoolean("is_active"));
            s.setJoinedDate(rs.getTimestamp("joined_date"));
            return s;
        }
    }
}
