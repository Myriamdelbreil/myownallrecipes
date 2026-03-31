class RecipeSearchService
  def initialize(params)
    @query = params[:ingredient_names]
    @page = params[:page] || 1
  end

  def call
    recipes = find_recipes
    recipes = fallback_to_basic_ingredients if recipes.empty?

    recipes.with_search_score
  end

  private

  def find_recipes
    Recipe.where(id: Recipe.search_by_name(@query))
          .or(Recipe.where(id: Recipe.search_by_ingredients_names(@query)))
  end

  def fallback_to_basic_ingredients
    basic_ids = Ingredient.where("name ILIKE ANY (array[?])", SHARED_INGREDIENTS).select(:id)
    Recipe.joins(:recipe_ingredients)
          .where(recipe_ingredients: { ingredient_id: basic_ids })
          .distinct
          .limit(9)
  end
end
