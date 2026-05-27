require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  test "should redirect new when not logged in" do
    get new_company_url
    assert_redirected_to login_url
  end

  test "should get edit for own company" do
    sign_in_as users(:one)

    get edit_company_url(companies(:one))

    assert_response :success
    assert_select "h1", text: "Upraviť firmu"
  end

  test "should update own company" do
    sign_in_as users(:one)

    patch company_url(companies(:one)), params: {
      company: {
        name: "Updated Company",
        ico: "12345678",
        dic: "1234567890",
        ic_dph: "SK1234567890",
        street: "Updated Street",
        city: "Updated City",
        postal_code: "12345",
        country: "Slovensko"
      }
    }

    assert_redirected_to profiles_url
    assert_equal "Updated Company", companies(:one).reload.name
  end

  test "should not edit another user's company" do
    sign_in_as users(:one)

    get edit_company_url(companies(:two))

    assert_response :not_found
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

  test "should select own company" do
    sign_in_as users(:one)

    patch select_company_url(companies(:another_one))

    assert_redirected_to profiles_url
    follow_redirect!
    assert_match "Other Company", response.body
  end
end
