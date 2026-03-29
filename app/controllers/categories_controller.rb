class CategoriesController < ApplicationController
  def index
    categories = Category.search_by_name(params[:query])
    @categories_count = categories.length
    @categories = categories.page(params[:page] || 1)
  end
end
