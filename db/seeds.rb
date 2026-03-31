# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Rails.logger.info('Importing categories...')
categories_to_import = 10.times.map do
  Category.new(name: "#{Faker::Food.ethnic_category} #{Faker::Number.between(from: 10, to: 200)}")
end
Category.import(categories_to_import)
Rails.logger.info('Import categories done !')
categories = Category.all

Rails.logger.info('Importing ingredients...')
ingredients_to_import = 100.times.map do
  Ingredient.new(name: "#{Faker::Food.ingredient} #{Faker::Number.between(from: 10, to: 200)}")
end
Ingredient.import(ingredients_to_import)
ingredients = Ingredient.all
Rails.logger.info('Import ingredients done !')

Rails.logger.info('Importing recipes...')
recipes_to_import = 500.times.map do
  recipe = Recipe.new(
    title: "#{Faker::Food.dish} #{Faker::Number.between(from: 200, to: 800)} #{Faker::Number.between(from: 200, to: 800)}",
    cook_time: Faker::Number.between(from: 10, to: 200),
    prep_time: Faker::Number.between(from: 10, to: 200),
    ratings: Faker::Number.between(from: 0.0, to: 5.0),
    image_url: Faker::LoremFlickr.image,
    cuisine: Faker::Food.ethnic_category,
    category_id: categories.sample,
  )
  ingredients = ingredients.sample(4)
  ingredients.each do |ingredient|
    recipe.recipe_ingredients.build(
      ingredient:,
      original_text: ingredient.name,
      unit: Ingreedy.dictionaries.current.units.keys.sample,
      quantity: Faker::Number.between(from: 0.0, to: 5.0),
    )
  end
  recipe
end

Recipe.import(recipes_to_import, recursive: true)
Rails.logger.info('Import recipes done !')
