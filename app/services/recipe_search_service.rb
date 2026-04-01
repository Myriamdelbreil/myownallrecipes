class RecipeSearchService
  def initialize(params)
    @query = params[:ingredient_names]
  end

  def call
    return Recipe.all if @query.blank?

    recipes = find_recipes
    recipes.exists? ? recipes : fallback_to_basic_ingredients
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
  end
end
