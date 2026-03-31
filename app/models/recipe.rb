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
  has_many :recipe_ingredients, dependent: :destroy, inverse_of: :recipe
  has_many :ingredients, through: :recipe_ingredients

  validates :cook_time, :prep_time, :title, :slug, presence: true

  # Scope de base pour inclure les calculs nécessaires au tri
  scope :with_stats, -> {
    joins(:ingredients)
      .select("recipes.*")
      .select("COUNT(ingredients.id) AS ingredients_count")
      .select("(recipes.prep_time + recipes.cook_time) AS total_duration")
      .group("recipes.id")
  }

  # Tri par score (ton calcul custom)
  scope :with_search_score, -> {
    with_stats
      .select("COUNT(ingredients.id) AS ingredients_count")
      .select("(COUNT(ingredients.id) * 10 + (COALESCE(recipes.prep_time, 0) + COALESCE(recipes.cook_time, 0)) * 0.5) AS search_score")
      .order(Arel.sql("search_score ASC"))
  }

  # Tri par durée (Somme des deux colonnes)
  scope :order_by_total_prep_time, ->(direction = :asc) {
    with_stats
      .order(Arel.sql("total_duration #{direction}"))
  }

  # Tri par nombre d'ingrédients
  scope :order_by_ingredients_count, ->(direction = :asc) {
    with_stats
      .order(Arel.sql("ingredients_count #{direction}"))
  }

  # Tes scopes de recherche
  pg_search_scope :search_by_name,
    against: :title,
    using: { tsearch: { any_word: false, prefix: true } }

  scope :search_by_ingredients_names, ->(query) {
    return Recipe.none if query.blank?
    words = query.downcase.split(/[\s,]+/).reject(&:blank?)
    like_conditions = words.map { "%#{_1}%" }

    joins(:ingredients)
      .where(words.map { "lower(ingredients.name) LIKE ?" }.join(" OR "), *like_conditions)
      .group("recipes.id")
      .having("COUNT(DISTINCT CASE #{words.each_with_index.map { |_, i| "WHEN lower(ingredients.name) LIKE ? THEN #{i}" }.join(" ")} END) = ?", *like_conditions, words.length)
  }

  def total_prep_time
    prep_time + cook_time
  end

  def formatted_prep_time
    total = total_prep_time
    total < 60 ? "#{total} min" : Time.at(total * 60).utc.strftime("%Hh%M").sub(/^0h/, '')
  end
end
