require "test_helper"

class IngredientsControllerTest < ActionDispatch::IntegrationTest
  class Index < self
    test "without query returns 200" do
      get ingredients_path
      assert_response :success
    end

    test "with filters returns 200 and filters SHARED_INGREDIENTS" do
      get ingredients_path, params: { q: "gar" }
      assert_response :success
    end

    test "when filters, it's case insensitive" do
      get ingredients_path, params: { q: "GAR" }
      assert_response :success
    end

    test "when filters with no match still returns 200" do
      get ingredients_path, params: { q: "zzznomatch" }
      assert_response :success
    end
  end

  class Chip < self
    test "returns 200" do
      post chip_ingredients_path, params: { combobox_values: "garlic,tomatoes" }
      assert_response :success
    end

    test "with empty values returns 200" do
      post chip_ingredients_path, params: { combobox_values: "" }
      assert_response :success
    end
  end
end
