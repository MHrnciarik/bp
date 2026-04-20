require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  setup do
    @company = companies(:one)
  end

  test "requires ico to be exactly 8 digits" do
    @company.ico = "1234567"
    assert_not @company.valid?

    @company.ico = "123456789"
    assert_not @company.valid?

    @company.ico = "12345678"
    assert @company.valid?
  end

  test "allows dic to be blank or 8 to 10 digits" do
    @company.dic = ""
    assert @company.valid?

    @company.dic = "1234567"
    assert_not @company.valid?

    @company.dic = "12345678901"
    assert_not @company.valid?

    @company.dic = "123456789"
    assert @company.valid?
  end

  test "allows ic dph to be blank or SK or CZ followed by 10 digits" do
    @company.ic_dph = ""
    assert @company.valid?

    @company.ic_dph = "SK123456789"
    assert_not @company.valid?

    @company.ic_dph = "DE1234567890"
    assert_not @company.valid?

    @company.ic_dph = "CZ1234567890"
    assert @company.valid?
  end

  test "requires postal code to be exactly 5 digits" do
    @company.postal_code = "1234"
    assert_not @company.valid?

    @company.postal_code = "123456"
    assert_not @company.valid?

    @company.postal_code = "12345"
    assert @company.valid?
  end
end
