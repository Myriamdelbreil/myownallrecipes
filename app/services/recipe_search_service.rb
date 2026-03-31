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
    # On force le left_joins pour que search_by_name et search_by_ingredients soient compatibles
    name_ids = Recipe.search_by_name(@query).pluck(:id)
    ingredient_ids = Recipe.search_by_ingredients_names(@query).pluck(:id)

    # On fusionne les IDs (le .uniq enlève les doublons)
    all_ids = (name_ids + ingredient_ids).uniq

    # On renvoie une relation basée sur ces IDs pour que les tris fonctionnent après
    Recipe.where(id: all_ids)
  end

  def fallback_to_basic_ingredients
    # On utilise SHARED_INGREDIENTS défini dans ton modèle ou ici
    # On reste sur une structure simple qui sera complétée par les scopes de tri
    basic_ids = Ingredient.where("name ILIKE ANY (array[?])", Recipe::SHARED_INGREDIENTS).pluck(:id)
    Recipe.joins(:recipe_ingredients)
          .where(recipe_ingredients: { ingredient_id: basic_ids })
          .group("recipes.id")
  end
end
