module RecipeSortable
  private

  def apply_sort_and_paginate(search_base, category: nil)
    recipes = category.presence ? search_base[:recipes].where(category:) : search_base[:recipes]
    recipes = case params[:sort]
              when 'duration'
                recipes.order_by_total_prep_time(safe_direction)
              when 'ingredients_count'
                recipes.order_by_ingredients_count(safe_direction)
              else
                recipes.with_search_score
              end

    @recipes = recipes.page(params[:page]).per(18)
    @recipes_count = search_base[:recipes_found] ? @recipes.total_count : 0
  end
end
