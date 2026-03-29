class PagesController < ApplicationController
  def home
    @top_categories = Category.joins(:recipes)
                              .group(:id)
                              .order('COUNT(recipes.id) DESC')
                              .limit(3)

    @recipes_per_category = @top_categories.index_with do |category|
      category.recipes
              .joins(:recipe_ingredients)
              .group('recipes.id')
              .order('COUNT(recipe_ingredients.id) ASC')
              .order(:ratings)
              .limit(6)
    end

    all_recipe_ids = @recipes_per_category.values.flatten.map(&:id)

    @ingredients_counts_per_recipe = RecipeIngredient.where(recipe_id: all_recipe_ids)
                                                    .group(:recipe_id)
                                                    .count
  end
end
