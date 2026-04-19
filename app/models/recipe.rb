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

  belongs_to :category, optional: true
  has_many :recipe_ingredients, dependent: :destroy, inverse_of: :recipe
  has_many :ingredients, through: :recipe_ingredients

  validates :title, :slug, presence: true
  validates :cook_time, :prep_time, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :with_stats, -> {
    joins(:ingredients)
      .select("recipes.*")
      .select("COUNT(ingredients.id) AS ingredients_count")
      .select("(recipes.prep_time + recipes.cook_time) AS total_duration")
      .group("recipes.id")
  }

  scope :with_search_score, -> {
    with_stats
      .select("COUNT(ingredients.id) AS ingredients_count")
      .select("(COUNT(ingredients.id) * 10 + (COALESCE(recipes.prep_time, 0) + COALESCE(recipes.cook_time, 0)) * 0.5) AS search_score")
      .order(Arel.sql("search_score ASC"))
  }

  scope :order_by_total_prep_time, ->(direction = :asc) {
    with_stats
      .order(Arel.sql("total_duration #{direction}"))
  }

  scope :order_by_ingredients_count, ->(direction = :asc) {
    with_stats
      .order(Arel.sql("ingredients_count #{direction}"))
  }

  # matches GIN index built with to_tsvector('simple', title)
  pg_search_scope :search_by_name,
    against: :title,
    using: { tsearch: { any_word: false, prefix: true, dictionary: 'simple' } } # 'simple' = no language-specific processing, just lowercase

  scope :search_by_ingredients_names, ->(query) {
    return Recipe.none if query.blank?
    words = query.split(/[\s,]+/).reject(&:blank?)
    like_conditions = words.map { "%#{_1}%" }

    joins(:ingredients)
      .where(words.map { "ingredients.name ILIKE ?" }.join(" OR "), *like_conditions)
      .group("recipes.id")
      .having("COUNT(DISTINCT CASE #{words.each_with_index.map { |_, i| "WHEN ingredients.name ILIKE ? THEN #{i}" }.join(" ")} END) = ?", *like_conditions, words.length)
  }

  def total_prep_time
    prep_time + cook_time
  end
end
