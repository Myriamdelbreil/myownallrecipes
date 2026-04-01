require "test_helper"

class CategoriesImageUrlBackfillServiceTest < ActiveSupport::TestCase
  setup do
    @service = CategoriesImageUrlBackfillService.new
  end

  test "updates image_url on categories that have none" do
    category = categories(:breakfast)
    recipes(:long_dish).update_columns(image_url: "http://example.com/chicken.jpg", category_id: category.id)
    category.update_column(:image_url, nil)

    @service.call

    assert_equal "http://example.com/chicken.jpg", category.reload.image_url
  end

  test "does not overwrite existing image_url" do
    category = categories(:breakfast)
    category.update_column(:image_url, "http://example.com/existing.jpg")

    @service.call

    assert_equal "http://example.com/existing.jpg", category.reload.image_url
  end

  test "skips categories with no recipes with image" do
    category = categories(:dessert)
    category.update_column(:image_url, nil)

    @service.call

    assert_nil category.reload.image_url
  end

  test "returns the number of updated categories" do
    category = categories(:breakfast)
    recipes(:long_dish).update_columns(image_url: "http://example.com/chicken.jpg", category_id: category.id)
    category.update_column(:image_url, nil)

    updated = @service.call

    assert_equal 1, updated
  end
end
