require 'test_helper'

class ExperimentsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Experiment.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Experiment.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Experiment.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to experiment_url(assigns(:experiment))
  end
  
  def test_edit
    get :edit, :id => Experiment.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Experiment.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Experiment.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Experiment.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Experiment.first
    assert_redirected_to experiment_url(assigns(:experiment))
  end
  
  def test_destroy
    experiment = Experiment.first
    delete :destroy, :id => experiment
    assert_redirected_to experiments_url
    assert !Experiment.exists?(experiment.id)
  end
end
