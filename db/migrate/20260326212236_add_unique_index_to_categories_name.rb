class AddUniqueIndexToCategoriesName < ActiveRecord::Migration[7.1]
  def up
    remove_index :categories, :name
    add_index :categories, :name, unique: true
  end

  def down
    remove_index :categories, :name
    add_index :categories, :name
  end
end
