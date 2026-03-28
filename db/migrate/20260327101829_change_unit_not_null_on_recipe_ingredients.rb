class ChangeUnitNotNullOnRecipeIngredients < ActiveRecord::Migration[7.1]
  def up
    change_column_null :recipe_ingredients, :unit, true
  end

  def down
    change_column_null :recipe_ingredients, :unit, false
  end
end
