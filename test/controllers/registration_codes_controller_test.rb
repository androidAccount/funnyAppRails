require 'test_helper'

class RegistrationCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @registration_code = registration_codes(:one)
  end

  test "should get index" do
    get registration_codes_url
    assert_response :success
  end

  test "should get new" do
    get new_registration_code_url
    assert_response :success
  end

  test "should create registration_code" do
    assert_difference('RegistrationCode.count') do
      post registration_codes_url, params: { registration_code: {  } }
    end

    assert_redirected_to registration_code_url(RegistrationCode.last)
  end

  test "should show registration_code" do
    get registration_code_url(@registration_code)
    assert_response :success
  end

  test "should get edit" do
    get edit_registration_code_url(@registration_code)
    assert_response :success
  end

  test "should update registration_code" do
    patch registration_code_url(@registration_code), params: { registration_code: {  } }
    assert_redirected_to registration_code_url(@registration_code)
  end

  test "should destroy registration_code" do
    assert_difference('RegistrationCode.count', -1) do
      delete registration_code_url(@registration_code)
    end

    assert_redirected_to registration_codes_url
  end
end
