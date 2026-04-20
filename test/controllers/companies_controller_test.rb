require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  test "should redirect new when not logged in" do
    get new_company_url
    assert_redirected_to login_url
  end

  test "should destroy own company" do
    sign_in_as users(:one)

    assert_difference("Company.count", -1) do
      delete company_url(companies(:one))
    end

    assert_redirected_to profiles_url
  end

  test "should not destroy another user's company" do
    sign_in_as users(:one)

    assert_no_difference("Company.count") do
      delete company_url(companies(:two))
    end
  end
end
