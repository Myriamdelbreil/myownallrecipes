class RecipesController < ApplicationController
  def index
    search_base = RecipeSearchService.new(params).call

    case params[:sort]
    when 'duration'
      recipes = search_base.order_by_total_prep_time(params[:direction] || :asc)
    when 'ingredients_count'
      recipes = search_base.order_by_ingredients_count(params[:direction] || :asc)
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
