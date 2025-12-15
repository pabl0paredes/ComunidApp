require "test_helper"

class ResidentSummaryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get resident_summary_index_url
    assert_response :success
  end

  test "should get show" do
    get resident_summary_show_url
    assert_response :success
  end
end
