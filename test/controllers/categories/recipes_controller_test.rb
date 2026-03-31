
require "test_helper"

class Categories::RecipesControllerTest < ActionDispatch::IntegrationTest
  class Index < self
    test "returns 200" do
      get category_recipes_path(categories(:breakfast))
      assert_response :success
    end

    test "with sort returns 200" do
      get category_recipes_path(categories(:breakfast)), params: { sort: "duration", direction: "asc" }
      assert_response :success
    end
  end
end
