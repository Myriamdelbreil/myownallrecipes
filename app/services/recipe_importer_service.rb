require 'open-uri'
require 'cgi'

class RecipeImporterService
  def initialize
    @file_path = ENV['DATABASE_JSON_URL']
  end

  def call

    ActiveRecord::Base.transaction do
      @categories = import_categories
      @ingredients = import_ingredients

      perform_recipe_import
    end
  end

  private

  def recipes_data
    @recipes_data ||=
      begin
        file_content = URI.open(@file_path).read
        JSON.parse(file_content)
      end
  end

  def parsed_ingredients
    @parsed_ingredients ||=
      begin
        all_raw_ingredients = recipes_data.pluck('ingredients').flatten.uniq
        all_raw_ingredients.each_with_object({}) do |raw_ingredient, hash|
          hash[raw_ingredient] = begin
            Ingreedy.parse(raw_ingredient)
          rescue Ingreedy::ParseFailed, StandardError
            raw_ingredient
          end
        end
      end
  end

  def import_categories
    categories_names = recipes_data.pluck('category').uniq.compact_blank
    Category.import(
      categories_names.map { |n| { name: n } },
      on_duplicate_key_ignore: true,
      validate: false
    )
    Category.all.index_by(&:name)
  end

  def import_ingredients
    ingredients_names = parsed_ingredients.values.map do |val|
      val.is_a?(Ingreedy::Parser::Result) ? val.ingredient : val
    end.uniq.compact_blank

    Ingredient.import(
      ingredients_names.map { |n| { name: n } },
      on_duplicate_key_ignore: true,
      validate: false
    )
    Ingredient.all.index_by(&:name)
  end

  def perform_recipe_import
    recipes_to_import = recipes_data.map { |data| build_recipe(data) }

    result = Recipe.import(
      recipes_to_import,
      recursive: true,
      validate: true,
      all_or_none: true
    )

    raise "Recipes' import failed" if result.failed_instances.any?
  end

  def build_recipe(data)
    recipe = Recipe.new(
      title: data['title'],
      cook_time: data['cook_time'],
      prep_time: data['prep_time'],
      ratings: data['ratings'],
      image_url: clean_image_url(data['image']),
      cuisine: data['cuisine'],
      category: @categories[data['category']]
    )

    data['ingredients'].each do |raw_ingredient|
      fetched_ingredient = parsed_ingredients[raw_ingredient]

      if fetched_ingredient.is_a?(Ingreedy::Parser::Result)
        recipe.recipe_ingredients.build(
          ingredient: @ingredients[fetched_ingredient.ingredient],
          original_text: raw_text,
          unit: fetched_ingredient.unit,
          quantity: fetched_ingredient.quantity,
        )
      else
        recipe.recipe_ingredients.build(
          ingredient: @ingredients[fetched_ingredient],
          original_text: raw_text,
        )
      end
    end

    recipe
  end

  def clean_image_url(raw_url)
    return nil if raw_url.blank?

    if raw_url.include?("meredithcorp.io") && raw_url.include?("url=")
      parsed_query = CGI.parse(URI.parse(raw_url).query)

      real_url = parsed_query["url"]&.first

      return real_url if real_url.present?
    end

    raw_url
  end
end
