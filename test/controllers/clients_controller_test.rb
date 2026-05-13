require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
    patch select_company_path(companies(:one))
  end

  test "only shows clients for the selected company" do
    get clients_path

    assert_response :success
    assert_match "Acme Corp", response.body
    assert_no_match "Gamma GmbH", response.body
  end

  test "creates a client" do
    assert_difference("Client.count", 1) do
      post clients_path, params: {
        client: {
          name: "Beta LLC",
          address: "Other Street 2",
          note: "Secondary client"
        }
      }
    end

    client = Client.order(:created_at).last

    assert_redirected_to clients_path
    assert_equal companies(:one), client.company
    assert_equal "Beta LLC", client.name
  end
end
