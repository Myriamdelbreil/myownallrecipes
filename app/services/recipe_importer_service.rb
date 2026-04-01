require 'open-uri'
require 'cgi'

class RecipeImporterService
  def initialize
    @file_path = ENV['DATABASE_JSON_URL']
  end

  def call
    data = recipes_data

    data.each_slice(100) do |batch|
      ActiveRecord::Base.transaction do
        categories = import_categories_for_batch(batch)
        ingredients = import_ingredients_for_batch(batch)

        perform_batch_import(batch, categories, ingredients)
      end
      GC.start
    end
  end

  private

  def recipes_data
    @recipes_data ||= JSON.parse(URI.open(@file_path).read)
  end

  def import_categories_for_batch(batch)
    names = batch.pluck('category').uniq.compact_blank
    image_by_category = batch.each_with_object({}) do |recipe, hash|
      name = recipe['category']
      hash[name] ||= clean_image_url(recipe['image']) if name.present?
    end
    categories_to_import = names.map do |name|
      Category.new(name: name, slug: "#{name.parameterize}-#{rand(10000)}", image_url: image_by_category[name])
    end
    Category.import(categories_to_import, on_duplicate_key_ignore: true, validate: false)
    Category.where(name: names).index_by(&:name)
  end

  def import_ingredients_for_batch(batch)
    raw_ingredients = batch.pluck('ingredients').flatten.uniq
    names = raw_ingredients.map do |raw|
      begin
        Ingreedy.parse(raw).ingredient
      rescue StandardError
        raw
      end
    end.uniq.compact_blank

    Ingredient.import(names.map { |n| { name: n } }, on_duplicate_key_ignore: true, validate: false)
    Ingredient.where(name: names).index_by(&:name)
  end

  def perform_batch_import(batch, categories, ingredients)
    recipes_to_import = batch.map { |data| build_recipe(data, categories, ingredients) }
    Recipe.import(recipes_to_import, recursive: true, validate: false)
  end

  def build_recipe(data, categories, ingredients)
    recipe = Recipe.new(
      title: data['title'],
      slug: "#{data['title'].parameterize}-#{rand(10000)}",
      cook_time: data['cook_time'],
      prep_time: data['prep_time'],
      ratings: data['ratings'],
      image_url: clean_image_url(data['image']),
      cuisine: data['cuisine'],
      category: categories[data['category']]
    )

    data['ingredients'].each do |raw_ingredient|
      begin
        parsed = Ingreedy.parse(raw_ingredient)
        recipe.recipe_ingredients.build(
          ingredient: ingredients[parsed.ingredient],
          original_text: raw_ingredient,
          unit: parsed.unit,
          quantity: parsed.amount
        )
      rescue StandardError
        recipe.recipe_ingredients.build(
          ingredient: ingredients[raw_ingredient],
          original_text: raw_ingredient
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
