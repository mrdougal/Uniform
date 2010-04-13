module Uniform
  module CartMethods

    def self.included(controller) # :nodoc:
      controller.send(:include, InstanceMethods)
      controller.extend(ClassMethods)
    end

    module ClassMethods
      def self.extended(controller)

        controller.helper_method :display_cart?
        controller.before_filter :find_cart

      end
    end

    module InstanceMethods
      
      private
      
      # Do we show the link to the cart
      def display_cart?
        true
      end

      
      # retrieve the cart_id from the session and then load from the database 
      # (or return a new order if no such id exists in the session)
      def find_cart 


        if !session[:cart_token].blank?
          # Since there is a cart in the session, we'll load it up
          @cart = Cart.find_or_create_by_token(session[:cart_token])
        else
          @cart = Cart.new
        end

        # Assign the cart to the session
        attach_cart_to_session
        @cart # Return the cart

      end

      def attach_cart_to_session
        session[:cart_token] = @cart.token
      end

    end

  end
end
