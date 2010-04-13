class Mailman < ActionMailer::Base
  
  # default_url_options[:host] = 'epson.local'
  
  
  # Sent to the user when they first signup
  def welcome_message(user)
    
    from        Uniform.configuration.mailer_sender
    recipients  user.email
    subject     'Welcome to the Computer Now portal'
    body        :user => user
  end
  
  
  def order_confirmation(quote)
    
    from        Uniform.configuration.mailer_sender
    recipients  quote.user.email
    reply_to    quote.user.bdm_email # If they hit reply it goes to the BDM
    subject     'Confirmation of your order'
    body        :quote => quote
    
  end
  
  # Only sent, if the user has a BDM (and consequently an account)
  def order_confirmation_to_bdm(quote)

    from        Uniform.configuration.mailer_sender
    recipients  quote.user.bdm_email
    subject     "Order #{quote.code} from #{quote.user_name} at #{quote.user.account}"
    body        :user => quote.user, :quote => quote
    
  end
  
end
