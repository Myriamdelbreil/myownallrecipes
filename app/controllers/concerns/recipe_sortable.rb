module RecipeSortable
  private

  def apply_sort_and_paginate(search_base)
    recipes = case params[:sort]
              when 'duration'
                search_base.order_by_total_prep_time(safe_direction)
              when 'ingredients_count'
                search_base.order_by_ingredients_count(safe_direction)
              else
                search_base.with_search_score
              end

    @recipes = recipes.page(params[:page]).per(18)
    @recipes_count = @recipes.total_count
  end
end
