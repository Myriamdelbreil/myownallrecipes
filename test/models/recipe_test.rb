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
require "test_helper"

class RecipeTest < ActiveSupport::TestCase

  class Helpers < self
    test "total_prep_time returns sum of prep_time and cook_time" do
      assert_equal 30, recipes(:pasta).total_prep_time
    end

    test "formatted_prep_time returns '30 min' when total is under 60" do
      assert_equal "30 min", recipes(:pasta).formatted_prep_time
    end

    test "formatted_prep_time returns formatted hours when total is 60 or more" do
      assert_equal "02h00", recipes(:long_dish).formatted_prep_time
    end
  end


  class Scopes < self
    test "order_by_total_prep_time asc returns shortest recipe first" do
      results = Recipe.order_by_total_prep_time(:asc).to_a
      durations = results.map { |r| r.prep_time + r.cook_time }
      assert_equal durations.sort, durations
    end

    test "order_by_total_prep_time desc returns longest recipe first" do
      results = Recipe.order_by_total_prep_time(:desc).to_a
      durations = results.map { |r| r.prep_time + r.cook_time }
      assert_equal durations.sort.reverse, durations
    end

    test "order_by_ingredients_count asc returns fewest ingredients first" do
      results = Recipe.order_by_ingredients_count(:asc).to_a
      counts = results.map(&:ingredients_count)
      assert_equal counts.sort, counts
    end

    test "search_by_ingredients_names returns recipes that have all queried ingredients" do
      results = Recipe.search_by_ingredients_names("garlic").pluck(:id)
      assert_includes results, recipes(:pasta).id
      assert_includes results, recipes(:garlic_soup).id
      assert_not_includes results, recipes(:long_dish).id
    end

    test "search_by_ingredients_names returns none for unknown ingredient" do
      assert_empty Recipe.search_by_ingredients_names("zzznomatch999")
    end
  end

end
