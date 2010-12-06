class SettingsController < ApplicationController
  def edit
    @page_id = "settings"
    @settings = Settings.first
  end
  
  def update
    @settings = Settings.first
    if @settings.update_attributes(params[:settings])
      flash[:notice] = "Zapisano zmiany w kompozycji."
      redirect_to settings_path
    else
      render settings_path
    end
  end

end
