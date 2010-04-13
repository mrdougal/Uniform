module Uniform
  class Routes

    # In your application's config/routes.rb, draw Uniform routes:
    #
    # @example
    #   map.resources :posts
    #   Uniform::Routes.draw(map)
    #
    def self.draw(map)
      
      # Session
      map.login  'login',  :controller => 'uniform/sessions', :action => 'new'
      map.logout 'logout', :controller => 'uniform/sessions', :action => 'destroy', :method => :delete
      map.session 'session', :controller => 'uniform/sessions', :action => 'create', :method => :post   

      # User
      map.signup 'signup', :controller => 'uniform/users', :action => 'new'
      map.confirm 'confirm/:code', :controller => 'uniform/users', :action => 'activate'
      map.resource :user, :except => [:new ], :controller => 'uniform/users' 
      
      # Cart
      map.resource :cart, :except => [:edit] 
      map.add_to_cart '/cart/add/:id', :controller => "carts", :action => 'add'
      map.remove_from_cart '/cart/remove/:id', :controller => "carts", :action => 'remove'
      
      
      # Checkout (for cart)
      map.resource :checkout do |checkout|
        checkout.resources :steps, :only => [:index, :show ], :controller => "checkout_steps" 
      end
      

    end

  end
end
