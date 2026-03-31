# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#  index_categories_on_slug  (slug) UNIQUE
#
require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  class Scopes < self
    test "search_by_name returns matching categories" do
      results = Category.search_by_name("break")
      assert_includes results, categories(:breakfast)
      assert_not_includes results, categories(:dessert)
    end

    test "search_by_name is case insensitive" do
      results = Category.search_by_name("BREAKFAST")
      assert_includes results, categories(:breakfast)
    end

    test "search_by_name returns all categories when query is blank" do
      results = Category.search_by_name("")
      assert_includes results, categories(:breakfast)
      assert_includes results, categories(:dessert)
    end
  end
end
