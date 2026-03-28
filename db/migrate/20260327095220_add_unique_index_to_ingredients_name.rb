class AddUniqueIndexToIngredientsName < ActiveRecord::Migration[7.1]
  def up
    remove_index :ingredients, :name
    add_index :ingredients, :name, unique: true
  end

  def down
    remove_index :ingredients, :name
    add_index :ingredients, :name
  end
end
