class AddSearchIndexes < ActiveRecord::Migration[7.1]
  def up
    # Required for trigram indexes — enables LIKE '%word%' pattern matching without sequential scan
    enable_extension "pg_trgm"

    # GIN (Generalized Inverted Index): maps each word/trigram to the rows containing it, efficient for full-text and trigram searches
    add_index :recipes, "to_tsvector('simple', title)",
      using: :gin,
      name: "index_recipes_on_title_tsearch"

    execute "CREATE INDEX index_ingredients_on_name_tsearch ON ingredients USING gin(to_tsvector('simple', name))"
    execute "CREATE INDEX index_ingredients_on_lower_name_trgm ON ingredients USING gin(lower(name) gin_trgm_ops)"
    execute "CREATE INDEX index_categories_on_lower_name_trgm ON categories USING gin(lower(name) gin_trgm_ops)"
  end

  def down
    remove_index :recipes, name: "index_recipes_on_title_tsearch"
    execute "DROP INDEX index_ingredients_on_name_tsearch"
    execute "DROP INDEX index_ingredients_on_lower_name_trgm"
    execute "DROP INDEX index_categories_on_lower_name_trgm"
    disable_extension "pg_trgm"
  end
end
