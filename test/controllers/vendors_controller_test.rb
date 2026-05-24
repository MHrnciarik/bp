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
          kind: "company",
          name: "Market Hall",
          ico: "23456789",
          dic: "2345678901",
          ic_dph: "SK2345678901",
          street: "Central Square 5",
          city: "Kosice",
          postal_code: "04001",
          country: "Slovensko",
          email: "billing@market.example",
          website: "www.market.example",
          phone: "+421 900 123 456",
          address: "Central Square 5",
          note: "Fresh food"
        }
      }
    end

    vendor = Vendor.order(:created_at).last

    assert_redirected_to vendors_path
    assert_equal companies(:one), vendor.company
    assert_equal "Market Hall", vendor.name
    assert_equal "23456789", vendor.ico
    assert_equal "Central Square 5, Kosice, 04001, Slovensko", vendor.address
    assert_equal "https://www.market.example", vendor.website
  end

  test "creates a private person vendor" do
    assert_difference("Vendor.count", 1) do
      post vendors_path, params: {
        vendor: {
          kind: "person",
          first_name: "Jana",
          last_name: "Novakova",
          street: "Personal Street 4",
          city: "Nitra",
          postal_code: "94901",
          country: "Slovensko"
        }
      }
    end

    vendor = Vendor.order(:created_at).last

    assert_redirected_to vendors_path
    assert vendor.person?
    assert_equal "Jana Novakova", vendor.name
    assert_nil vendor.ico
  end
end
