class IngredientsController < ApplicationController
  def index
    if params[:q].present?
      @ingredients = Ingredient.search_by_name(params[:q])
    else
      @ingredients = Ingredient.none
    end

    render turbo_stream: helpers.async_combobox_options(@ingredients)
  end

  def chip
    @ingredients = Ingredient.where(id: params[:combobox_values])
    render turbo_stream: helpers.combobox_selection_chips_for(@ingredients)
  end
end
