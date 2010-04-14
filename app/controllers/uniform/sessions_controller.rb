class Uniform::SessionsController < ApplicationController

  unloadable

  # skip_before_filter :authenticate, :only => [:new, :create, :destroy]
  # protect_from_forgery :except => :create
  # filter_parameter_logging :password

  def new

    @session = UserSession.new   
  end

  def create

    @session = UserSession.new(params[:user_session])

    if @session.save
      flash[:notice] = "Welcome back #{current_user.first_name}"
      redirect_back_or_default
    else
      
      flash[:notice] = @session.errors.on_base
      render :action => 'new'
    end
  end

  def destroy
    
    # We have been logged in if we want to logout
    if logged_in?
      
      @session = UserSession.find(params[:id])
      @session.destroy
    end
    
    # Redirect the user home
    redirect_to root_path
    
  end


  private

  # We send them back to the page they wanted, or default
  def redirect_back_or_default(default = root_path)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end


end
