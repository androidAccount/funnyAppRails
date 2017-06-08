require 'test_helper'

class AddCategoryTablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @add_category_table = add_category_tables(:one)
  end

  test "should get index" do
    get add_category_tables_url
    assert_response :success
  end

  test "should get new" do
    get new_add_category_table_url
    assert_response :success
  end

  test "should create add_category_table" do
    assert_difference('AddCategoryTable.count') do
      post add_category_tables_url, params: { add_category_table: {  } }
    end

    assert_redirected_to add_category_table_url(AddCategoryTable.last)
  end

  test "should show add_category_table" do
    get add_category_table_url(@add_category_table)
    assert_response :success
  end

  test "should get edit" do
    get edit_add_category_table_url(@add_category_table)
    assert_response :success
  end

  test "should update add_category_table" do
    patch add_category_table_url(@add_category_table), params: { add_category_table: {  } }
    assert_redirected_to add_category_table_url(@add_category_table)
  end

  test "should destroy add_category_table" do
    assert_difference('AddCategoryTable.count', -1) do
      delete add_category_table_url(@add_category_table)
    end

    assert_redirected_to add_category_tables_url
  end
end
