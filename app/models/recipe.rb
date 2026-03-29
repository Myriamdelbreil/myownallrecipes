# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  cook_time   :integer          not null
#  cuisine     :string
#  image_url   :string
#  prep_time   :integer          not null
#  ratings     :float
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#
# Indexes
#
#  index_recipes_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
class Recipe < ApplicationRecord
  belongs_to :category, optional: true

  has_many :recipe_ingredients, dependent: :destroy,  inverse_of: :recipe
  has_many :ingredients, through: :recipe_ingredients

  validates :cook_time, presence: true
  validates :prep_time, presence: true
  validates :title, presence: true

  def total_prep_time
    prep_time + cook_time
  end

  def formatted_prep_time
    if total_prep_time < 60
      "#{total_prep_time} min"
    else
      Time.at(total_prep_time * 60).utc.strftime("%Hh%M").sub(/^0h/, '')
    end
  end
end
