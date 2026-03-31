require "test_helper"

class RecipeSearchServiceTest < ActiveSupport::TestCase
  class BlankQuery < self
    test "returns all recipes when query is blank" do
      result = RecipeSearchService.new({}).call
      assert_equal Recipe.count, result.count
    end

    test "returns all recipes when ingredient_names is empty string" do
      result = RecipeSearchService.new({ ingredient_names: "" }).call
      assert_equal Recipe.count, result.count
    end
  end

  class SearchInIngredientNames < self
    test "returns recipes that contain the searched ingredient" do
      result = RecipeSearchService.new({ ingredient_names: "garlic" }).call
      ids = result.pluck(:id)
      assert_includes ids, recipes(:pasta).id
      assert_includes ids, recipes(:garlic_soup).id
    end

    test "does not return recipes without the searched ingredient" do
      result = RecipeSearchService.new({ ingredient_names: "garlic" }).call
      assert_not_includes result.pluck(:id), recipes(:long_dish).id
    end
  end

  class SearchInRecipeName < self
    test "returns recipe when query matches the title" do
      result = RecipeSearchService.new({ ingredient_names: "Pasta" }).call
      assert_includes result.pluck(:id), recipes(:pasta).id
    end
  end

  test "falls back to basic ingredients when no direct match is found" do
    result = RecipeSearchService.new({ ingredient_names: "zzznomatch" }).call
    assert result.count > 0
  end

  test "result is chainable with order scopes" do
    result = RecipeSearchService.new({ ingredient_names: "garlic" }).call
    assert_nothing_raised do
      result.order_by_total_prep_time(:asc).to_a
    end
  end
end
