class AddSlugColumnsToRecipesAndCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :slug, :string
    add_column :categories, :slug, :string
  end
end
