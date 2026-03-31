require "test_helper"

class RecipeSearchServiceTest < ActiveSupport::TestCase
  def setup
    @service = RecipeSearchService.new
  end

  test "should do something" do
    assert @service.call
  end
end
