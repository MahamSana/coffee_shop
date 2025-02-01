# test/controllers/items_controller_test.rb
require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index as JSON" do
    get items_url, as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert json_response.is_a?(Array), "Response should be an array of items"
  end
end
