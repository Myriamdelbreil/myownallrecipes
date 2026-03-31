class IngredientsController < ApplicationController
  def index
    if params[:q].present?
      @ingredients = SHARED_INGREDIENTS.select { |i| i.include?(query) }
    else
      @ingredients = SHARED_INGREDIENTS.first(20)
    end

    render turbo_stream: helpers.async_combobox_options(@ingredients)
  end

  def chip
    values = params[:combobox_values].to_s.split(",").reject(&:blank?)

    @selected_ingredients = values.map do |val|
      Ingredient.new(name: val.capitalize)
    end
    render turbo_stream: helpers.combobox_selection_chips_for(@selected_ingredients)
  end
end
