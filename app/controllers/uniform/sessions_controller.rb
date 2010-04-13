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



  # def flash_failure_after_create
  #   flash.now[:failure] = translate(:bad_email_or_password,
  #     :scope   => [:clearance, :controllers, :sessions],
  #     :default => "Bad email or password.")
  # end
  # 
  # def flash_success_after_create
  #   flash[:success] = translate(:signed_in, :default =>  "Signed in.")
  # end
  # 
  # def flash_notice_after_create
  #   flash[:notice] = translate(:unconfirmed_email,
  #     :scope   => [:clearance, :controllers, :sessions],
  #     :default => "User has not confirmed email. " <<
  #                 "Confirmation email will be resent.")
  # end
  # 
  # def url_after_create
  #   '/'
  # end
  # 
  # def flash_success_after_destroy
  #   flash[:success] = translate(:signed_out, :default =>  "Signed out.")
  # end
  # 
  # def url_after_destroy
  #   sign_in_url
  # end

end
