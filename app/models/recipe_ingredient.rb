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
    "#{formatted_quantity} #{unit} #{ingredient.name}"
  end

  private

  def formatted_quantity
    r = quantity.rationalize(0.01)
    if r.denominator == 1
      r.numerator.to_s
    elsif r.denominator <= 16
      whole = r.numerator / r.denominator
      frac = r - whole
      whole > 0 ? "#{whole} #{frac.numerator}/#{frac.denominator}" : "#{r.numerator}/#{r.denominator}"
    else
      quantity.round(2)
    end
  end
end
