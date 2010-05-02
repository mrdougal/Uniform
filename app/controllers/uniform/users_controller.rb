class Uniform::UsersController < ApplicationController
  
  unloadable

  # In case they came from the checkout, so we can send them back there
  before_filter :record_return_to_checkout, :only => [:new ]
  before_filter :find_user, :except => [:new, :create, :activate] 

  # GET /user
  def show
  end

  # GET /user/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    if @user.save
      
      # Log the user in now
      @session = UserSession.create(@user)
      
      # Send the user a welcome message
      Mailman.deliver_welcome_message @user
      
      # Send a notification to CompNow
      Mailman.deliver_notification_of_new_user @user
      
      # Send them back to what they tried to access before, 
      # or render a nice welcome message for the user
      redirect_back_or_welcome
    else
      
      # Re-display the signup form as there are errors
      render :action => 'new'
    end
  end

  # PUT /users/1
  def update

    if @user.update_attributes(params[:user])
      flash[:notice] = 'Your details were updated.'
      render :action => 'show'
    else
      render :action => 'edit'
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to(users_url)
  end
  
  # GET /confirm/big-long-hash
  def activate
    
    @user = User.find_by_activation_code!(params[:code])
    if @user.activate
      # Since they activated, we can log them in
      @session = UserSession.create(@user)
    end
  end
  
  private
  
  def find_user
    
    # They have to be logged in for us to find our who they are
    login_required
    @user = current_user
  end
  
  # We send them back to the page they wanted, or default
  def redirect_back_or_welcome
    
    if session[:return_to]
      redirect_to(session[:return_to])
      session[:return_to] = nil
    else
      render :template => 'uniform/users/welcome'
    end
  end
  
  
end
