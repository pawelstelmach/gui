class MediatorsController < ApplicationController
  before_filter :require_user

  def new
    if params[:mediator_type] == "R"
      @name = "Repositories"
    else
      @name = "Ontologies"
    end
    @mediator = Mediator.new
    render :layout => false
  end

  def create
    @mediator = Mediator.new(params[:mediator])
    @mediator.user_id=current_user.id
    @mediator.password == params[:confirm_password]
    if @mediator.save
      redirect_to repositories_path
    else
      redirect_to repositories_path
    end
  end
  
  def view_stats
    mediator_array = Mediator.find_all_by_user_id(current_user.id)
    @mediators = Array.new
    mediator_array.each do | m |
      @mediators << { :name => m.name, :last_time => m.get_last_response_time, :avg_time => m.get_avrage_response_time }
    end
    render :layout => false
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
