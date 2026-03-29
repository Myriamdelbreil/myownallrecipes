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
class RecipeIngredient < ApplicationRecord
  belongs_to :recipe, inverse_of: :recipe_ingredients
  belongs_to :ingredient, inverse_of: :recipe_ingredients

  validates :original_text, presence: true
  validates :quantity, presence: true
  validates :unit, presence: true

  def detailed_quantity
    "#{quantity} #{unit} #{ingredient.name}"
  end
end
