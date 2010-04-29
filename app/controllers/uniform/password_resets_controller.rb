class Uniform::PasswordResetsController < ApplicationController
  
  
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  
  def new
    
  end
  
  def show
    redirect_to edit_password_reset_path(params[:id])
  end
  
  def create
    
    @user = User.find_by_email(params[:user][:email])
    
    if @user
      
      @user.reset_perishable_token!
      Mailman.deliver_password_reset_instructions(@user)
      
      flash[:notice] = "Instructions to reset your password have been emailed to you"
      # Send them back to the main page
      redirect_to root_url
      
    else # Nobody was found
      
      flash[:notice] = "No user was found with that email address"
      render :action => :new
    end
  end
  
  def edit

  end

  def update
    
    # So that if other attributes are empty, we can still save
    @user.update_by_admin = true
    
    @user.password = nil if params[:user][:password].blank?
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    
    if @user.save
      
      # We'll log them in now
      @session = UserSession.create @user
      
      flash[:notice] = "Your password has been successfully updated"
      redirect_to root_url
      
    else
      render :action => :edit
    end
  end

  private


  def load_user_using_perishable_token

    @user = User.find_by_perishable_token(params[:id])

    unless @user
      
      flash[:notice] = "We could not locate your account. " +
                       "If you are having issues try copying and pasting the URL " +
                       "from your email into your browser."
        
      redirect_to root_url
      
    end
  end
  
  
end