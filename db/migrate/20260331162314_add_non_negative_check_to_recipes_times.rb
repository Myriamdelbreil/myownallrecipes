class AddNonNegativeCheckToRecipesTimes < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL
      ALTER TABLE recipes
        ADD CONSTRAINT check_cook_time_non_negative CHECK (cook_time >= 0),
        ADD CONSTRAINT check_prep_time_non_negative CHECK (prep_time >= 0);
    SQL
  end

  def down
    execute <<~SQL
      ALTER TABLE recipes
        DROP CONSTRAINT IF EXISTS check_cook_time_non_negative,
        DROP CONSTRAINT IF EXISTS check_prep_time_non_negative;
    SQL
  end
end
