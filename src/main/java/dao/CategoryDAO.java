package dao;

import java.util.List;
import models.Category;

public interface CategoryDAO {

	List<Category> findAll();

	Category findById(int id);

	boolean existsByName(String name, int excludeId);

	int countProducts(int categoryId);

	void insert(Category category);

	void update(Category category);

	void delete(int id);
}