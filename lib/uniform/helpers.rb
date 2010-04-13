module Uniform
  module Helpers

    # Used by the navigation to decide if the link is current or is a part of the current link
    def current_section(url)
      # Match the first part of the request url with our own url
      (request.path =~ Regexp.new("#{url}/*")) ? 'current' : ''
    end

    def title(msg)

      # We have a new string so that msg isn't effected
      s = String.new(msg.to_s)
      content_for :title do
        s << ' - ' unless s.blank? # Only string if it's not blank
      end
    end

    # Store the passed in string in the header block
    # For rendering out in the header later
    def header(msg)
      content_for :header do
        "<h1>#{msg}</h1>"
      end
    end

    # Display the current and total count of pages in the title
    def pagination_title(set)
      return unless set.respond_to?('total_pages')
      "page #{set.current_page} of #{set.total_pages}" if set.total_pages > 1
    end


    # Are we sending the user back to the checkout, once they have authenticated?
    def will_return_user_to_checkout?
      !!(session[:return_to] && session[:return_to] =~ /checkout/)
    end
    
    # Returns the path to the full or empty cart pngs (images)
    def cart_image

      var = 'empty' unless @cart
      var = @cart.empty? ? 'empty' : 'full'
      
      "icons/general/cart-#{var}.png"
    end
    
    # Helper method to display count and price of the cart
    def link_to_cart(text = 'Your cart')

      css_class = '' # Good as empty
                  
      if @cart
        unless @cart.empty?
          text += ": (#{@cart.size}) #{number_to_currency(@cart.price)}"
          css_class = 'full' 
        end
        
        link_to text, cart_path, :class => css_class, :title => text
      end
    end

  end
end
