require "test_helper"
require "minitest/mock"

class RecipeImporterServiceTest < ActiveSupport::TestCase
  setup do
    @json_url = "http://fakeurl.com/recipes.json"
    ENV['DATABASE_JSON_URL'] = @json_url
  end

  test "should import recipes and associations from json" do
    json_data = [
      {
        "title" => "Tarte aux pommes",
        "category" => "Dessert",
        "ingredients" => ["1 kg de pommes"],
        "cook_time" => 30,
        "prep_time" => 15
      }
    ].to_json

    URI.stub :open, StringIO.new(json_data) do
      service = RecipeImporterService.new
      assert_difference('Recipe.count' => 1, 'Category.count' => 1, 'Ingredient.count' => 1, 'RecipeIngredient.count' => 1) do
        service.call
      end
    end
  end

  test "should assign image_url to category from first recipe in batch" do
    json_data = [
      {
        "title" => "Recette A",
        "category" => "Dessert",
        "ingredients" => ["100 g de sucre"],
        "cook_time" => 10,
        "prep_time" => 5,
        "image" => "http://example.com/cake.jpg"
      },
      {
        "title" => "Recette B",
        "category" => "Dessert",
        "ingredients" => ["200 g de farine"],
        "cook_time" => 10,
        "prep_time" => 5,
        "image" => "http://example.com/other.jpg"
      }
    ].to_json

    URI.stub :open, StringIO.new(json_data) do
      RecipeImporterService.new.call

      category = Category.find_by(name: "Dessert")
      assert_equal "http://example.com/cake.jpg", category.image_url
    end
  end

  test "should parse units and quantities correctly" do
    json_data = [
      {
        "title" => "Recette Test",
        "category" => "Plat",
        "ingredients" => ["500 g de farine"],
        "cook_time" => 10,
        "prep_time" => 5
      }
    ].to_json

    URI.stub :open, StringIO.new(json_data) do
      RecipeImporterService.new.call

      recipe = Recipe.find_by(title: "Recette Test")
      ri = recipe.recipe_ingredients.first

      assert_not_nil ri
      assert_equal 500.0, ri.quantity.to_f
      assert_equal "gram", ri.unit
    end
  end

  test "should handle malformed ingredients gracefully" do
    json_data = [
      {
        "title" => "Recette Bizarre",
        "category" => "Plat",
        "ingredients" => ["un peu de sel"],
        "cook_time" => 5,
        "prep_time" => 5
      }
    ].to_json

    URI.stub :open, StringIO.new(json_data) do
      RecipeImporterService.new.call

      recipe = Recipe.find_by(title: "Recette Bizarre")
      ri = recipe.recipe_ingredients.first

      assert_not_nil ri
      assert_equal "un peu de sel", ri.original_text
      assert_nil ri.quantity
    end
  end
end
