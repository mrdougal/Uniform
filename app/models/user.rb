# The user table is actually stored in the clients database. 
# We have created an sql view, so that we can shared the users data between all of the rails websites.
# We *could* have used different database connections for users and account, although this becomes problematic when we 
# need to inforce relationships between objects that use different database connections. (such as users having orders)
# 
class User < ActiveRecord::Base

  # Where we define the default markup
  cattr_accessor :default_markup
  @@default_markup = 17


  
  # Flag so that admins can update details, and have them part incomplete
  attr_accessor :update_by_admin
  attr_accessor :account_name
  
  acts_as_authentic
  
  
  belongs_to :account
  
  has_many :quotes
  
  before_create :create_activation_code
  
  # Required attributes
  validates_presence_of     :email, :name, :message => "This needs to be filled in" 

  # Password
  validates_presence_of     :password,                   :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?

  validates_presence_of :phone_number
  validates_length_of :phone_number, :within => 6..20, :unless => Proc.new { |user| user.phone_number.blank? }
  

  # Attributes that are required only once the user updates later on
  validates_presence_of :address, :on => :update, :unless => :update_by_admin?
  validates_presence_of :suburb, :on => :update, :unless => :update_by_admin?
  validates_presence_of :state, :on => :update, :unless => :update_by_admin?
  validates_presence_of :postcode, :on => :update, :unless => :update_by_admin?
  validates_numericality_of :postcode, :unless => Proc.new { |user| user.postcode.blank? }



  validates_uniqueness_of   :hansa_code, :if => lambda { |u| !u.hansa_code.blank?  }
  
  # Terms of service
  attr_accessor             :terms_of_service
  validates_acceptance_of   :terms_of_service, 
                              :message => "You need to have read and accepted the terms to continue", 
                              :on => :create, 
                              :unless => :update_by_admin? 
  
  
  named_scope :ordered_by_name, :order => 'name asc'
  
  # Need to make sure that the verified and hansa_code attributes are protected
  attr_protected :verified, :hansa_code, :admin

  
  
  
  
  def to_s
    name
  end
  
  def code
    hansa_code
  end
  
  # We only want activated people from compnow to be admins
  def is_admin?
    staff? && activated?
  end
  
  def staff?
    !!(email =~ %r{@compnow.com.au})
  end
  
  # Activate the user
  def activate
    
    self.activated_at = Time.now
    self.activation_code = nil
    
    # This is protected, otherwise we would do 'update_attributes'
    self.admin = staff?
    
    # Don't fire callbacks
    self.save(false)
  end
  
  def activated?
    !!activated_at
  end
  
  def first_name
    self.name.split(' ')[0]
  end
  
  
  # Used to calculate the prices of products
  def markup
    
    return account.markup if account && !account.markup.nil?
    self.class.default_markup
    
  end
  
  # Returns the bdm if there is one
  def bdm
    return nil unless account && account.bdm
    account.bdm
  end
  
  # Return the email address of the bdm
  def bdm_email
    
    return nil if bdm.nil?
    
    bdm.email
  end
  
  # Used at signup
  def self.valid_states
    ['Victoria', 'New South Wales',
      'South Australia', 'Tasmania', 
      'Queensland', 'Western Australia',
      'Northern Territory', 'ACT']
  end
  
  
  protected

  def update_by_admin?
    !!update_by_admin
  end
  
  def password_required?
    encrypted_password.blank? || !password.blank?
  end
  
  # Create a 'random' activation code
  # We're using a friendly token, as the hex tokens are very long, an will wrap in most mail clients,
  # which will break the url. (in outlook at least)
  def create_activation_code
    self.activation_code = Authlogic::Random.friendly_token
  end
  
  
end
