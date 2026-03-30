class AddConstraintsAndIndexToSlugs < ActiveRecord::Migration[7.1]
  def up
    change_column_null :recipes, :slug, false
    change_column_null :categories, :slug, false

    add_index :recipes, :slug, unique: true
    add_index :categories, :slug, unique: true
  end

  def down
    change_column_null :recipes, :slug, true
    change_column_null :categories, :slug, true

    remove_index :recipes, :slug, unique: true
    remove_index :categories, :slug, unique: true
  end
end
