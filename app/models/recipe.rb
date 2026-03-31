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
  include PgSearch::Model

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


  # scope :by_minimal_ingredients, -> {
  #   joins(:recipe_ingredients)
  #     .group(:id)
  #     .order(Arel.sql('COUNT(recipe_ingredients.id) ASC'))
  # }

  scope :search_by_ingredients_names, ->(query) {
    return Recipe.none if query.blank?

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
      )
  }

  pg_search_scope :search_by_name,
    against: :title,
    using: {
      tsearch: { any_word: false, prefix: true }
    }

  scope :with_search_score, -> {
    select("recipes.*")
    .select("COUNT(ingredients.id) AS ingredients_count")
    .select("(COUNT(ingredients.id) * 10 + (COALESCE(prep_time, 0) + COALESCE(cook_time, 0)) * 0.5) AS search_score")
    .joins(:ingredients)
    .group("recipes.id")
    .order("search_score ASC")
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
