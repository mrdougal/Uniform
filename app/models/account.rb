# The account table is actually stored in the clients database. 
# We have created an sql view, so that we can shared the users data between all of the rails websites.
# We *could* have used different database connections for users and account, although this becomes problematic when we 
# need to inforce relationships between objects that use different database connections. (such as users having orders)
# 
class Account < ActiveRecord::Base
  
  
  has_many :users, :dependent => :nullify
  belongs_to :bdm

  before_validation :strip_name

  validates_presence_of :name
  validates_uniqueness_of :name
  
  # We only want to check the hansa_code if it's not blank?
  validates_uniqueness_of :hansa_code, :if => lambda { |a| !a.hansa_code.blank? }
  
  default_scope :order => 'name asc'
  
  
  
  # DISPLAY_VALUES = ['description', 'phone','phone_alt','fax', 'address']
  
  def code
    hansa_code
  end
  
  def to_s
    name
  end
  
  def approved?
    !!hansa_code
  end
  
  
  
  # Give a list of industries
  # Used to build the navigation, amongst other things
  def self.adobe_industries
    ['Commercial','Education','K12','Government']
  end
  
  
  private
  
  # Strip excess whitespace from the name, so that we don't end up with similar looking accounts
  # that have excess whitespace at the start or end. As then they would be considered unique, 
  # although they would look the same
  def strip_name
    self.name.strip! if self.name
  end
  
end
