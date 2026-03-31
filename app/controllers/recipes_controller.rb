class RecipesController < ApplicationController
  def index
    search_base = RecipeSearchService.new(params).call

    case params[:sort]
    when 'duration'
      recipes = search_base.order_by_total_prep_time(safe_direction)
    when 'ingredients_count'
      recipes = search_base.order_by_ingredients_count(safe_direction)
    else
      recipes = search_base.with_search_score
    end
    @recipes_count = recipes.length

    @recipes = recipes.page(params[:page]).per(18)
  end

  def show
    @recipe = Recipe.friendly.find(params[:id])
  end
end
