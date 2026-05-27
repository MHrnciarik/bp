require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear
    @user = users(:one)
  end

  test "should get new" do
    get new_password_path

    assert_response :success
    assert_select "h1", text: "Obnova hesla"
  end

  test "should send reset instructions for existing email" do
    assert_difference("ActionMailer::Base.deliveries.size", 1) do
      post passwords_path, params: { email: @user.email.upcase }
    end

    assert_redirected_to login_path

    mail = ActionMailer::Base.deliveries.last
    assert_equal [ @user.email ], mail.to
    assert_equal "Obnova hesla", mail.subject
    assert_match %r{http://example.com/passwords/.+/edit}, mail.text_part.decoded
    assert_match "Odkaz je platný 15 minút.", mail.text_part.decoded
  end

  test "should not reveal unknown email" do
    assert_no_difference("ActionMailer::Base.deliveries.size") do
      post passwords_path, params: { email: "missing@example.com" }
    end

    assert_redirected_to login_path
  end

  test "should get edit with valid token" do
    get edit_password_path(@user.password_reset_token)

    assert_response :success
    assert_select "h1", text: "Nové heslo"
  end

  test "should reject invalid token" do
    get edit_password_path("invalid-token")

    assert_redirected_to new_password_path
  end

  test "should update password with valid token" do
    token = @user.password_reset_token

    assert_changes -> { @user.reload.password_digest } do
      patch password_path(token), params: {
        password: "newpassword123",
        password_confirmation: "newpassword123"
      }
    end

    assert_redirected_to login_path
    assert @user.reload.authenticate("newpassword123")
  end

  test "should render errors for invalid password reset" do
    token = @user.password_reset_token

    assert_no_changes -> { @user.reload.password_digest } do
      patch password_path(token), params: {
        password: "short",
        password_confirmation: "short"
      }
    end

    assert_response :unprocessable_entity
    assert_match "Heslo je príliš krátke", response.body
  end
end
