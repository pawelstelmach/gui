class StaticController < ApplicationController
  def testhelp
    render :layout => false
  end
end