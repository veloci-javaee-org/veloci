package service;

import java.util.List;

import dao.CategoryDAO;
import dao.CategoryDAOImpl;
import exceptions.ValidationException;
import models.Category;

public class CategoryServiceImpl implements CategoryService {

	private final CategoryDAO categoryDAO = new CategoryDAOImpl();

	
	@Override
	public List<Category> getAll() {
		return categoryDAO.findAll();
	}

	
	@Override
	public Category getById(int id) {
		return categoryDAO.findById(id);
	}

	
	@Override
	public int countProducts(int categoryId) {
		return categoryDAO.countProducts(categoryId);
	}

	
	@Override
	public void create(Category category) throws ValidationException {
		validate(category, -1);
		categoryDAO.insert(category);
	}

	
	@Override
	public void update(Category category) throws ValidationException {
		validate(category, category.getId());
		categoryDAO.update(category);
	}

	
	@Override
	public void delete(int id) {
		categoryDAO.delete(id);
	}
	

	// ── Validation ───────────────────────────────────────────────────────
	private void validate(Category category, int excludeId) throws ValidationException {
		if (category.getName() == null || category.getName().trim().isEmpty()) {
			throw new ValidationException("Category name is required.");
		}
		if (category.getName().trim().length() > 100) {
			throw new ValidationException("Category name must be 100 characters or less.");
		}
		if (categoryDAO.existsByName(category.getName().trim(), excludeId)) {
			throw new ValidationException("A category with this name already exists.");
		}
	}
}