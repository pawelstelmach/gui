class SettingsController < ApplicationController
  before_filter :require_user
  
  def edit
    @page_id = "parameters"
    @user = current_user
    render :layout => 'config'
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to settings_path
    else
      render render :action => 'edit'
    end
  end

end
