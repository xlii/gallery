require 'test_helper'

class UnregisteredPhotosControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    UnregisteredPhoto.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    UnregisteredPhoto.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to root_url
  end
end
