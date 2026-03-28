# require "test_helper"

# class RecipeImporterServiceTest < ActiveSupport::TestCase
#   def setup
#     @service = RecipeImporterService.new
#   end

#   test "should do something" do
#     assert @service.call
#   end
# end
require "test_helper"

class RecipeImporterServiceTest < ActiveSupport::TestCase
  def setup
    @json_content = file_fixture("recipes.json").read

    # On simule la variable d'environnement pour Render/Local
    ENV["DATABASE_JSON_URL"] = "http://fakeurl.com/recipes.json"
  end

  test "should import recipes and associations from json" do
    # On stub URI.open pour qu'il renvoie notre fichier local au lieu d'aller sur internet
    # On simule un objet qui répond à .read
    mock_response = Minitest::Mock.new
    mock_response.expect :read, @json_content

    URI.stub :open, mock_response do
      assert_difference ["Recipe.count", "Category.count"], 1 do
        assert_difference "Ingredient.count", 3 do
          RecipeImporterService.new.call
        end
      end
    end

    # Vérifications de précision
    recipe = Recipe.find_by(title: "Golden Sweet Cornbread")
    assert_not_nil recipe
    assert_equal "Cornbread", recipe.category.name

    # Test de la contrainte enlevée (quantité nil)
    salt_to_taste = recipe.recipe_ingredients.find_by(original_text: "salt to taste")
    assert_nil salt_to_taste.quantity
    assert_equal "salt to taste", salt_to_taste.original_text
  end

  test "should parse units and quantities correctly" do
    mock_response = Minitest::Mock.new
    mock_response.expect :read, @json_content

    URI.stub :open, mock_response do
      RecipeImporterService.new.call
    end

    flour = RecipeIngredient.find_by(original_text: "1 cup all-purpose flour")
    assert_equal 1.0, flour.quantity
    assert_equal "cup", flour.unit
    assert_equal "all-purpose flour", flour.ingredient.name
  end
end
