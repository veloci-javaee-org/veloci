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
	public void create(Category category) throws ValidationException {
		validate(category);
		String name = category.getName().trim();
		if (categoryDAO.existsByName(name, -1)) {
			throw new ValidationException("Category already exists.");
		}
		category.setName(name);
		categoryDAO.insert(category);
	}

	@Override
	public void update(Category category) throws ValidationException {
		validate(category);
		String name = category.getName().trim();
		if (categoryDAO.existsByName(name, category.getId())) {
			throw new ValidationException("Category already exists.");
		}
		category.setName(name);
		categoryDAO.update(category);
	}

	@Override
	public void delete(int id) {
		categoryDAO.delete(id);
	}

	@Override
	public int countProducts(int categoryId) {
		return categoryDAO.countProducts(categoryId);
	}

	@Override
	public boolean existsByName(String name, int excludeId) {
		return categoryDAO.existsByName(name, excludeId);
	}

	private void validate(Category category) throws ValidationException {
		if (category == null) {
			throw new ValidationException("Category is required.");
		}
		if (category.getName() == null || category.getName().trim().isEmpty()) {
			throw new ValidationException("Category name is required.");
		}
		if (category.getName().trim().length() > 100) {
			throw new ValidationException("Category name must be 100 characters or less.");
		}
	}
}
