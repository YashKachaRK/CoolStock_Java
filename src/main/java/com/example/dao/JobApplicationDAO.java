package com.example.dao;

import com.example.model.JobApplication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class JobApplicationDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM job_applications WHERE email = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
        return count != null && count > 0;
    }

    // ── INSERT ────────────────────────────────────────────────────────────────

    public int save(JobApplication app) {
        String sql = "INSERT INTO job_applications (full_name, email, phone, role, cover_letter, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                app.getFullName(),
                app.getEmail(),
                app.getPhone(),
                app.getRole(),
                app.getCoverLetter(),
                "PENDING");
    }

    // ── SELECT ALL ────────────────────────────────────────────────────────────

    public List<JobApplication> findAll() {
        String sql = "SELECT * FROM job_applications ORDER BY applied_at DESC";
        return jdbcTemplate.query(sql, new JobApplicationRowMapper());
    }

    // ── SELECT BY ID ──────────────────────────────────────────────────────────

    public JobApplication findById(int id) {
        String sql = "SELECT * FROM job_applications WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, new JobApplicationRowMapper(), id);
    }

    // ── UPDATE STATUS ─────────────────────────────────────────────────────────

    public int updateStatus(int id, String status) {
        String sql = "UPDATE job_applications SET status = ? WHERE id = ?";
        return jdbcTemplate.update(sql, status, id);
    }

    // ── DELETE ────────────────────────────────────────────────────────────────

    public int delete(int id) {
        String sql = "DELETE FROM job_applications WHERE id = ?";
        return jdbcTemplate.update(sql, id);
    }

    // ── Row Mapper ────────────────────────────────────────────────────────────

    private static class JobApplicationRowMapper implements RowMapper<JobApplication> {
        @Override
        public JobApplication mapRow(ResultSet rs, int rowNum) throws SQLException {
            JobApplication app = new JobApplication();
            app.setId(rs.getInt("id"));
            app.setFullName(rs.getString("full_name"));
            app.setEmail(rs.getString("email"));
            app.setPhone(rs.getString("phone"));
            app.setRole(rs.getString("role"));
            app.setCoverLetter(rs.getString("cover_letter"));
            app.setStatus(rs.getString("status"));
            app.setAppliedAt(rs.getTimestamp("applied_at")); // Timestamp extends java.util.Date
            return app;
        }
    }
}
