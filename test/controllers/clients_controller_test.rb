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
          kind: "company",
          name: "Beta LLC",
          ico: "23456789",
          dic: "2345678901",
          ic_dph: "SK2345678901",
          street: "Other Street 2",
          city: "Kosice",
          postal_code: "04001",
          country: "Slovensko",
          email: "billing@beta.example",
          website: "www.beta.example",
          phone: "+421 900 123 456",
          address: "Other Street 2",
          note: "Secondary client"
        }
      }
    end

    client = Client.order(:created_at).last

    assert_redirected_to clients_path
    assert_equal companies(:one), client.company
    assert_equal "Beta LLC", client.name
    assert_equal "23456789", client.ico
    assert_equal "billing@beta.example", client.email
    assert_equal "https://www.beta.example", client.website
    assert_equal "+421 900 123 456", client.phone
    assert_equal "Other Street 2, Kosice, 04001, Slovensko", client.address
  end

  test "creates a private person client" do
    assert_difference("Client.count", 1) do
      post clients_path, params: {
        client: {
          kind: "person",
          first_name: "Jana",
          last_name: "Novakova",
          street: "Personal Street 4",
          city: "Nitra",
          postal_code: "94901",
          country: "Slovensko",
          email: "jana@example.com",
          phone: "+421 900 555 555"
        }
      }
    end

    client = Client.order(:created_at).last

    assert_redirected_to clients_path
    assert client.person?
    assert_equal "Jana Novakova", client.name
    assert_equal "Jana Novakova", client.display_name
    assert_nil client.ico
  end

  test "updates a client website without protocol" do
    patch client_path(clients(:acme)), params: {
      client: {
        kind: "company",
        name: "Acme Corp",
        ico: "12345678",
        dic: "1234567890",
        ic_dph: "SK1234567890",
        street: "Example Street 1",
        city: "Bratislava",
        postal_code: "81101",
        country: "Slovensko",
        website: "www.acme.example"
      }
    }

    assert_redirected_to client_path(clients(:acme))
    assert_equal "https://www.acme.example", clients(:acme).reload.website
  end

  test "does not create a client without required business details" do
    assert_no_difference("Client.count") do
      post clients_path, params: {
        client: {
          kind: "company",
          name: "Only ICO",
          ico: "23456789"
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
