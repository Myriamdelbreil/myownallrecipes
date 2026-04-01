class Categories::RecipesController < ApplicationController
  include RecipeSortable
  before_action :set_category

  def index
    apply_sort_and_paginate(RecipeSearchService.new(params).call, category: @category)
  end

  private

  def set_category
    @category = Category.friendly.find(params[:category_id])
  end
end
