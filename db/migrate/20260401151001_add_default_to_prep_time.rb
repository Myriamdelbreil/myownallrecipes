class AddDefaultToPrepTime < ActiveRecord::Migration[7.1]
  def up
    change_column_default :recipes, :prep_time, from: nil, to: 0
  end

  def down
    change_column_default :recipes, :prep_time, from: 0, to: nil
  end
end
