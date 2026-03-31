# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#  index_categories_on_slug  (slug) UNIQUE
#
class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  before_validation :generate_slug, if: :name_changed?


  validates :name, presence: true
  has_many :recipes


  scope :search_by_name, ->(query) {
    return all if query.blank?

    words = query.downcase.split(/[\s,]+/).reject(&:blank?)
    like_conditions = words.map { "%#{_1}%" }

    where(
      words.map { "lower(name) LIKE ?" }.join(" OR "),
      *like_conditions
    )
  }
end
