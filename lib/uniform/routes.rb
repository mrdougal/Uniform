module Uniform
  class Routes

    # In your application's config/routes.rb, draw Uniform routes:
    #
    # Because not applications need a cart or signup.
    # So if your application only requires sesssion_paths, you only need to include that
    # 
    # eg: Uniform::Routes.draw_session_paths(map)
    #
    def self.draw(map)
      
      draw_session_paths(map)
      draw_signup_paths(map)
      draw_cart_and_checkout_paths(map)
      draw_rescue_paths(map)
      
    end
    
    def self.draw_session_paths(map)

      # Session
      map.login  'login',  :controller => 'uniform/sessions', :action => 'new'
      map.logout 'logout', :controller => 'uniform/sessions', :action => 'destroy', :method => :delete
      map.session 'session', :controller => 'uniform/sessions', :action => 'create', :method => :post   
    end
    
    def self.draw_signup_paths(map)

      # User
      map.signup 'signup', :controller => 'uniform/users', :action => 'new'
      map.confirm 'confirm/:code', :controller => 'uniform/users', :action => 'activate'
      map.resource :user, :except => [:new ], :controller => 'uniform/users' 
      
      # We need the password reset links
      map.resources :password_resets, 
                    :except => [ :destroy, :index ], 
                    :as => 'password-reset', 
                    :controller => 'uniform/password_resets'
      
    end
    
    def self.draw_cart_and_checkout_paths(map)
      
      # Cart
      map.resource :cart, :except => [:edit] 
      map.add_to_cart '/cart/add/:id', :controller => "carts", :action => 'add'
      map.remove_from_cart '/cart/remove/:id', :controller => "carts", :action => 'remove'
      
      # Checkout (for cart)
      map.resource :checkout do |checkout|
        checkout.resources :steps, :only => [:index, :show ], :controller => "checkout_steps" 
      end
      
    end

    def self.draw_rescue_paths(map)
      
      # Rescues, which are called internally by Apache
      map.with_options :controller => "application" do |site|

        site.connect 'rescues/404', :action => "not_found" 
        site.connect 'rescues/403', :action => "not_allowed" 
        site.connect 'rescues/422', :action => "change_rejected" 
      end 

      
    end


  end
end
