namespace :categories do
  desc "Backfill image_url on categories from their recipes"
  task backfill_images: :environment do
    updated = CategoriesImageUrlBackfillService.new.call
    puts "Done. #{updated} categories updated."
  end
end
