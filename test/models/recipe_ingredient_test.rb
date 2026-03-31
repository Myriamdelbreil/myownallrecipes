# == Schema Information
#
# Table name: recipe_ingredients
#
#  id            :bigint           not null, primary key
#  original_text :string           not null
#  quantity      :float
#  unit          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ingredient_id :bigint           not null
#  recipe_id     :bigint           not null
#
# Indexes
#
#  index_recipe_ingredients_on_ingredient_id  (ingredient_id)
#  index_recipe_ingredients_on_recipe_id      (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (ingredient_id => ingredients.id)
#  fk_rails_...  (recipe_id => recipes.id)
#
require "test_helper"

class RecipeIngredientTest < ActiveSupport::TestCase
  test "detailed_quantity combines quantity, unit and ingredient name" do
    ri = recipe_ingredients(:pasta_tomatoes) # quantity=2.0, unit=cup, ingredient=tomatoes
    assert_equal "2.0 cup tomatoes", ri.detailed_quantity
  end
end
