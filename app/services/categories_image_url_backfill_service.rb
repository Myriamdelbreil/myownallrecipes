class CategoriesImageUrlBackfillService
  def call
    image_by_category = Recipe.where.not(image_url: nil)
                              .select("DISTINCT ON (category_id) category_id, image_url")
                              .each_with_object({}) { |r, h| h[r.category_id] = r.image_url }
    categories = Category.where(image_url: nil, id: image_by_category.keys).map do |category|
      category.image_url = image_by_category[category.id]
      category
    end

    Category.import(categories, on_duplicate_key_update: [:image_url], validate: false)
  end
end
