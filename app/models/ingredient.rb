# == Schema Information
#
# Table name: ingredients
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ingredients_on_name  (name) UNIQUE
#
class Ingredient < ApplicationRecord
  include PgSearch::Model

  validates :name, presence: true

  has_many :recipe_ingredients, dependent: :destroy,  inverse_of: :ingredient
  has_many :recipes, through: :recipe_ingredients

    def to_combobox_display
      name
    end
end
