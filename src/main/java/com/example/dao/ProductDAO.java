package com.example.dao;

import com.example.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class ProductDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Product> findAll() {
        String sql = "SELECT * FROM products WHERE is_active = TRUE ORDER BY name ASC";
        return jdbcTemplate.query(sql, new ProductRowMapper());
    }

    public Product findById(int id) {
        String sql = "SELECT * FROM products WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, new ProductRowMapper(), id);
    }
    
    public Product findByCode(String code) {
        String sql = "SELECT * FROM products WHERE product_code = ?";
        List<Product> products = jdbcTemplate.query(sql, new ProductRowMapper(), code);
        return products.isEmpty() ? null : products.get(0);
    }

    public int save(Product product) {
        String sql = "INSERT INTO products (product_code, name, category, flavor, price, stock, pcs_per_box, description) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                product.getProductCode(),
                product.getName(),
                product.getCategory(),
                product.getFlavor(),
                product.getPrice(),
                product.getStock(),
                product.getPcsPerBox(),
                product.getDescription());
    }

    public int update(Product product) {
        String sql = "UPDATE products SET name=?, category=?, flavor=?, price=?, stock=?, pcs_per_box=?, description=? " +
                     "WHERE product_code=?";
        return jdbcTemplate.update(sql,
                product.getName(),
                product.getCategory(),
                product.getFlavor(),
                product.getPrice(),
                product.getStock(),
                product.getPcsPerBox(),
                product.getDescription(),
                product.getProductCode());
    }

    public int delete(String productCode) {
        String sql = "UPDATE products SET is_active = FALSE WHERE product_code = ?";
        return jdbcTemplate.update(sql, productCode);
    }

    public int reduceStock(int productId, int quantity) {
        String sql = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";
        return jdbcTemplate.update(sql, quantity, productId, quantity);
    }

    public int countTotalProducts() {
        String sql = "SELECT COUNT(*) FROM products WHERE is_active = TRUE";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }

    public int countLowStock(int threshold) {
        String sql = "SELECT COUNT(*) FROM products WHERE is_active = TRUE AND stock < ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, threshold);
    }

    public int addStock(int id, int amount) {
        String sql = "UPDATE products SET stock = stock + ? WHERE id = ?";
        return jdbcTemplate.update(sql, amount, id);
    }

    private static class ProductRowMapper implements RowMapper<Product> {
        @Override
        public Product mapRow(ResultSet rs, int rowNum) throws SQLException {
            Product p = new Product();
            p.setId(rs.getInt("id"));
            p.setProductCode(rs.getString("product_code"));
            p.setName(rs.getString("name"));
            p.setCategory(rs.getString("category"));
            p.setFlavor(rs.getString("flavor"));
            p.setPrice(rs.getBigDecimal("price"));
            p.setStock(rs.getInt("stock"));
            p.setPcsPerBox(rs.getInt("pcs_per_box"));
            p.setDescription(rs.getString("description"));
            p.setActive(rs.getBoolean("is_active"));
            p.setCreatedAt(rs.getTimestamp("created_at"));
            return p;
        }
    }
}
