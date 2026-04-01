class RecipeSearchService
  def initialize(params)
    @query = params[:ingredient_names]
  end

  def call
    return { recipes: Recipe.all, recipes_found: true } if @query.blank?

    recipes = find_recipes
    if recipes.exists?
      { recipes:, recipes_found: true }
    else
      { recipes: fallback_to_basic_ingredients, recipes_found: false }
    end
  end

  private

  def find_recipes
    name_ids = Recipe.search_by_name(@query).select("recipes.id")
    ingredient_ids = Recipe.search_by_ingredients_names(@query).select("recipes.id")

    Recipe.where(id: name_ids).or(Recipe.where(id: ingredient_ids))
  end

  def fallback_to_basic_ingredients
    basic_ids = Ingredient.where("name ILIKE ANY (array[?])", SHARED_INGREDIENTS).pluck(:id)
    Recipe.joins(:recipe_ingredients)
          .where(recipe_ingredients: { ingredient_id: basic_ids })
          .group("recipes.id")
          .limit(18)
  end
end
