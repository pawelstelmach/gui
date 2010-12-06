require 'test_helper'

class ExperimentTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Experiment.new.valid?
  end
end
