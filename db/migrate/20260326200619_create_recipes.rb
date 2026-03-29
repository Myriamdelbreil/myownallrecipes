class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.integer :cook_time, null: false
      t.integer :prep_time, null: false
      t.float :ratings
      t.string :cuisine
      t.string :image_url
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
