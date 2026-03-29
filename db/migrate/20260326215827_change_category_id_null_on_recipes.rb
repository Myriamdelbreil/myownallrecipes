class ChangeCategoryIdNullOnRecipes < ActiveRecord::Migration[7.1]
  def up
    change_column_null :recipes, :category_id, true
  end

  def down
    change_column_null :recipes, :category_id, false
  end
end
