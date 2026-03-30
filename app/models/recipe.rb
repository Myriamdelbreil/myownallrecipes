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
#  slug        :string           not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#
# Indexes
#
#  index_recipes_on_category_id  (category_id)
#  index_recipes_on_slug         (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
class Recipe < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  before_validation :generate_slug, if: :title_changed?

  belongs_to :category, optional: true

  has_many :recipe_ingredients, dependent: :destroy,  inverse_of: :recipe
  has_many :ingredients, through: :recipe_ingredients

  validates :cook_time, presence: true
  validates :prep_time, presence: true
  validates :title, presence: true
  validates :slug, presence: true

  scope :search_by_ingredients_names, ->(query) {
    return all if query.blank?

    words = query.downcase.split(/[\s,]+/).reject(&:blank?)
    like_conditions = words.map { "%#{_1}%" }

    joins(:ingredients)
      .where(
        words.map { "lower(ingredients.name) LIKE ?" }.join(" OR "),
        *like_conditions
      )
      .group("recipes.id")
      .having(
        "COUNT(DISTINCT CASE #{words.each_with_index.map { |_, i| "WHEN lower(ingredients.name) LIKE ? THEN #{i}" }.join(" ")} END) = ?",
        *like_conditions, words.length
      ).or(
        where("name LIKE ?", like_conditions)
      )
  }

  scope :search_by_ingredients_ids, ->(ingredient_ids) {
    return all if ingredient_ids.blank?

    ids = ingredient_ids.is_a?(String) ? ingredient_ids.split(",") : ingredient_ids

    joins(:ingredients)
      .where(ingredients: { id: ids })
      .group("recipes.id")
      .having("COUNT(DISTINCT ingredients.id) = ?", ids.length)
  }

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
