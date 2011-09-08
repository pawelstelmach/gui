require File.dirname(__FILE__) + '/../test_helper'
require 'composer_engine_services_controller'

class ComposerEngineServicesController; def rescue_action(e) raise e end; end

class ComposerEngineServicesControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = ComposerEngineServicesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
end
