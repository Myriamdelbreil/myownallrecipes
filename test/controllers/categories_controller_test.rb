require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  class Index < self
    test "returns 200" do
      get categories_path
      assert_response :success
    end

    test "with search query returns 200" do
      get categories_path, params: { query: "break" }
      assert_response :success
    end

    test "with search shows matching category" do
      get categories_path, params: { query: "Breakfast" }
      assert_response :success
      assert_select "body", /Breakfast/
    end
  end
end
