class RecipesController < ApplicationController
  def index
    recipe_ids = Recipe.search_by_name(params[:query]).ids + Recipe.search_by_ingredients_names(params[:query]).ids + Recipe.search_by_ingredients_ids(Array(params[:ingredient_ids])).ids
    recipes = Recipe.includes(recipe_ingredients: :ingredient).where(id: recipe_ids)
    @recipes_count = recipes.length
    @ingredients = Ingredient.where(id: params[:ingredient_ids].split(', '))
    if recipes.empty?
      basic_ingredient_ids = Ingredient.where("name ILIKE ANY (array[?])", Ingredient::BASIC_CEREALS).ids
      recipes = Recipe
                .where(recipe_ingredients: { ingredient_id: basic_ingredient_ids })
                .distinct
                .limit(9)
    end
    @recipes = recipes.page(params[:page] || 1)
    @ingredients_counts_per_recipe =
      RecipeIngredient.where(recipe_id: recipe_ids)
      .group(:recipe_id)
      .count
  end

  def show
    @recipe = Recipe.friendly.find(params[:id])
  end
end
