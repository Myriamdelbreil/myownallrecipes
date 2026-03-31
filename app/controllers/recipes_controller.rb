class RecipesController < ApplicationController
  include RecipeSortable

  def index
    apply_sort_and_paginate(RecipeSearchService.new(params).call)
  end

  def show
    @recipe = Recipe.friendly.find(params[:id])
  end
end
