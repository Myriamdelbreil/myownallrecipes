class Categories::RecipesController < ApplicationController
  before_action :set_category

  def index
    @recipes = @category.recipes.includes(recipe_ingredients: :ingredient).page(params[:page] || 1)
    @ingredients_counts_per_recipe =
      RecipeIngredient.where(recipe_id: @recipes.ids)
      .group(:recipe_id)
      .count
  end

  private

  def set_category
    @category = Category.friendly.find(params[:category_id])
  end
end
