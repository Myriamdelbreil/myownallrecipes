namespace :recipes do
  desc "Import recipes from allrecipes JSON"
  task import: :environment do
    Rails.logger.info('Start importing recipes')

    RecipeImporterService.new.call

    Rails.logger.info('Import finished')
    Rails.logger.info("#{Recipe.count} recipes, #{Ingredient.count} ingredients.")
    Rails.logger.info("#{RecipeIngredient.count} recipe_ingredients, #{Category.count} categories.")
  rescue => e
    Rails.logger.warn("Import failed, #{e.message}")
  end
end
