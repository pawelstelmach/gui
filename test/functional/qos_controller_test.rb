require 'test_helper'

class QosControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Qos.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Qos.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Qos.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to qos_url(assigns(:qos))
  end
  
  def test_edit
    get :edit, :id => Qos.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Qos.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Qos.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Qos.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Qos.first
    assert_redirected_to qos_url(assigns(:qos))
  end
  
  def test_destroy
    qos = Qos.first
    delete :destroy, :id => qos
    assert_redirected_to qos_url
    assert !Qos.exists?(qos.id)
  end
end
