require 'test_helper'

class QosTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Qos.new.valid?
  end
end
