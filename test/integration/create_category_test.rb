require 'test_helper'

class CreateCategoryTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: 'johndoe', email: 'johndoe@example.com',
                              password: 'password', admin: true)
    sign_in_as(@admin_user)
  end

  test 'get new category form and create category' do
    get new_category_path
    # assert_template "categories/new"
    assert_response :success
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: 'Sports' } }
      follow_redirect!
    end
    assert_response :success
    assert_match 'Sports', response.body
    # assert_template "categories/index"
    # assert_match "sports", response.body
  end

  test 'get new category form and reject invalid category submission' do
    get new_category_path
    assert_response :success
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: ' ' } }
    end
    assert_match 'errors', response.body
    assert_select 'div.alert'
    # assert_select 'h4.alert-heading'
  end
end
