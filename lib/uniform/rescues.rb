module Uniform
  module Rescues
    module ClassMethods
      
      def self.extended(controller)
      
        controller.rescue_from ActionController::RoutingError, :with => :not_found
        controller.rescue_from ActionController::UnknownAction, :with => :not_found
        controller.rescue_from ActionController::InvalidAuthenticityToken, :with => :not_allowed
        controller.rescue_from ActiveRecord::RecordNotFound, :with => :not_found
        controller.rescue_from ActiveRecord::RecordInvalid, :with => :change_rejected
        controller.rescue_from ActiveRecord::RecordNotSaved, :with => :change_rejected

      end
    end
    
    module InstanceMethods
      
      def not_found
        render :template => 'shared/rescues/not_found', :status => 404 
      end

      def not_allowed
        render :template => 'shared/rescues/not_allowed', :status => 403
      end

      def change_rejected
        render :template => 'shared/rescues/change_rejected', :status => 422 
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
  
end