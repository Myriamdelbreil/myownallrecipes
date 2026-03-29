class IngredientsController < ApplicationController
  def index
    if params[:q].present?
      @ingredients = Ingredient.left_joins(:recipe_ingredients)
                           .where("ingredients.name ILIKE ?", "%#{params[:q]}%")
                           .group("ingredients.id")
                           .order("COUNT(recipe_ingredients.id) DESC")
    else
      @ingredients = Ingredient.none
    end

    render turbo_stream: helpers.async_combobox_options(@ingredients)
  end
end
