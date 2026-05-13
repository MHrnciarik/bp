require "test_helper"

class VendorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
    patch select_company_path(companies(:one))
  end

  test "only shows vendors for the selected company" do
    get vendors_path

    assert_response :success
    assert_match "Corner Shop", response.body
    assert_no_match "Supply Store", response.body
  end

  test "creates a vendor" do
    assert_difference("Vendor.count", 1) do
      post vendors_path, params: {
        vendor: {
          name: "Market Hall",
          address: "Central Square 5",
          note: "Fresh food"
        }
      }
    end

    vendor = Vendor.order(:created_at).last

    assert_redirected_to vendors_path
    assert_equal companies(:one), vendor.company
    assert_equal "Market Hall", vendor.name
  end
end
