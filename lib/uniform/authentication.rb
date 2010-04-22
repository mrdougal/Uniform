module Uniform
  module Authentication

    def self.included(controller) # :nodoc:
      controller.send(:include, InstanceMethods)
      controller.extend(ClassMethods)
    end

    module ClassMethods
      def self.extended(controller)

        controller.helper_method :logged_in?, :current_user_session, :current_user, :requires_login

      end
    end

    module InstanceMethods
      
      
      # Send the user of to authenticate
      def login_required

        unless logged_in?
          record_return_to
          flash[:notice] = "You need to be logged in to access that page"

          redirect_to login_path
          return false
        end
      end
      
      def require_no_user
        if logged_in?
          flash[:notice] = "You need to be logged out access that page"
          redirect_to login_path
          return false
          
        end
      end

      # AUTHLOGIC METHODS

      def logged_in?
        current_user
      end

      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.record
      end

      private

      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end

      def record_return_to
        session[:return_to] = request.request_uri
      end 

      def record_return_to_checkout
        # If we have referred them via the checkout, we'll send them back there.
        session[:return_to] = checkout_path if request.referer =~ %r{#{checkout_url}*}
      end

    end

  end
end
