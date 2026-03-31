class Categories::RecipesController < ApplicationController
  before_action :set_category

  def index
    search_base = RecipeSearchService.new(params).call.where(category: @category)

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

  private

  def set_category
    @category = Category.friendly.find(params[:category_id])
  end
end
