require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  test "should redirect new when not logged in" do
    get new_company_url
    assert_redirected_to login_url
  end
end
