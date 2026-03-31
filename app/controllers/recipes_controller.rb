class RecipesController < ApplicationController
  def index
    @recipes = RecipeSearchService.new(params).call.page(@page)

    @recipes_count = @recipes.total_count
  end

  def show
    @recipe = Recipe.friendly.find(params[:id])
  end
end
