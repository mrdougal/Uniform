class Mailman < ActionMailer::Base
  
  # default_url_options[:host] = 'epson.local'
  
  
  # Sent to the user when they first signup
  def welcome_message(user)
    
    from        Uniform.configuration.mailer_sender
    recipients  user.email
    subject     'Welcome to the Computers Now customer portal system'
    body        :user => user
  end
  
  def notification_of_new_user(user)

    from        Uniform.configuration.mailer_sender
    recipients  Uniform.configuration.mailer_sender
    subject     "New customer portal user created"
    body        :user => user
  end
  
  def password_reset_instructions(user)
    
    from        Uniform.configuration.mailer_sender
    recipients  user.email
    subject     'Instructions for resetting your password on Computers Now customer portal system'
    body        :user => user
  end
  
  
  def order_confirmation(quote)
    
    from        Uniform.configuration.mailer_sender
    recipients  quote.user.email
    
    # BCC the wildcard address, if the user doesn't have a bdm
    bcc         Uniform.configuration.mailer_sender unless quote.user.bdm
    
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
