class AddColumnImageUrlToCategories < ActiveRecord::Migration[7.1]
  def up
    add_column :categories, :image_url, :string
    CategoriesImageUrlBackfillService.new.call
  end

  def down
    remove_colum :categories, :image_url
  end
end
