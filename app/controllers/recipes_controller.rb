class RecipesController < ApplicationController
  def index
    @recipes = Recipe.includes(recipe_ingredients: :ingredient).all.page(params[:page] || 1)
    @ingredients_counts_per_recipe =
      RecipeIngredient.where(recipe_id: @recipes.ids)
      .group(:recipe_id)
      .count
  end

  def show
    @recipe = Recipe.find(params[:id])
  end
end
