package service;

import java.util.List;

import exceptions.ValidationException;
import models.Category;

public interface CategoryService {

    List<Category> getAll();

    Category getById(int id);

    int countProducts(int categoryId);

    void create(Category category) throws ValidationException;

    void update(Category category) throws ValidationException;

    void delete(int id);
}