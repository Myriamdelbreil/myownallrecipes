require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  class Index < self
    test "returns 200" do
      get recipes_path
      assert_response :success
    end

    test "with ingredient search returns 200" do
      get recipes_path, params: { ingredient_names: "garlic" }
      assert_response :success
    end

    test "when sorted by duration returns 200" do
      get recipes_path, params: { sort: "duration", direction: "asc" }
      assert_response :success
    end

    test "when sorted by ingredients_count returns 200" do
      get recipes_path, params: { sort: "ingredients_count", direction: "desc" }
      assert_response :success
    end
  end

  class Show < self
    test "returns 200" do
      get recipe_path(recipes(:pasta))
      assert_response :success
    end

    test "with friendly slug returns 200" do
      get recipe_path("pasta-bolognese")
      assert_response :success
    end

    test "with unknown slug raises RecordNotFound" do
      assert_raises(ActiveRecord::RecordNotFound) do
        get recipe_path("does-not-exist")
      end
    end
  end
end
