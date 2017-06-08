require 'test_helper'

class AdminprofilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @adminprofile = adminprofiles(:one)
  end

  test "should get index" do
    get adminprofiles_url
    assert_response :success
  end

  test "should get new" do
    get new_adminprofile_url
    assert_response :success
  end

  test "should create adminprofile" do
    assert_difference('Adminprofile.count') do
      post adminprofiles_url, params: { adminprofile: {  } }
    end

    assert_redirected_to adminprofile_url(Adminprofile.last)
  end

  test "should show adminprofile" do
    get adminprofile_url(@adminprofile)
    assert_response :success
  end

  test "should get edit" do
    get edit_adminprofile_url(@adminprofile)
    assert_response :success
  end

  test "should update adminprofile" do
    patch adminprofile_url(@adminprofile), params: { adminprofile: {  } }
    assert_redirected_to adminprofile_url(@adminprofile)
  end

  test "should destroy adminprofile" do
    assert_difference('Adminprofile.count', -1) do
      delete adminprofile_url(@adminprofile)
    end

    assert_redirected_to adminprofiles_url
  end
end
