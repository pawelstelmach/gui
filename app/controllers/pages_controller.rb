class PagesController < ApplicationController
  before_filter :require_user
  
  def home
    @page_id = "home"
    render
  end
  
  def settings
    @page_id = "settings"
  end
  
#  def get_photo
#    Dir.chdir("#{RAILS_ROOT}/public/images/#{params[:site]}")
#    files = Dir.glob("*")
#    id = params[:id].to_i
#    @site = params[:site]
#	@current = id
#    @first = 0
#    @last = files.length-1
#    @next = id == @last ? @last : id+1
#    @prev = id == @first ? @first : id-1
#    @image = files[id]
#    render :layout => false
#  end

end
