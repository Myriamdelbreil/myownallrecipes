class RecipesController < ApplicationController
  def index
    recipes = Recipe.includes(recipe_ingredients: :ingredient).search_by_ingredients_names(params[:query])
    recipes = recipes.search_by_ingredients_ids(Array(params[:ingredient_ids]))
    @recipes_count = recipes.length
    if recipes.empty?
      basic_ingredient_ids = Ingredient.where("name ILIKE ANY (array[?])", Ingredient::BASIC_CEREALS).ids
      recipes = Recipe.joins(:recipe_ingredients)
                .where(recipe_ingredients: { ingredient_id: basic_ingredient_ids })
                .distinct
                .limit(9)
    end
    @recipes = recipes.page(params[:page] || 1)
    @ingredients_counts_per_recipe =
      RecipeIngredient.where(recipe_id: @recipes.ids)
      .group(:recipe_id)
      .count
  end

  def show
    @recipe = Recipe.friendly.find(params[:id])
  end
end
