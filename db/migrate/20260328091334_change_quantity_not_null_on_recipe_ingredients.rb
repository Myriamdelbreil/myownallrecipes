class ChangeQuantityNotNullOnRecipeIngredients < ActiveRecord::Migration[7.1]
  def up
    change_column_null :recipe_ingredients, :quantity, true
  end

  def down
    change_column_null :recipe_ingredients, :quantity, false
  end
end
