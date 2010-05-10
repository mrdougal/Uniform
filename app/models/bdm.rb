class Bdm < User
  
  # Effectively only admins are considered BDM's
  default_scope :order => 'name asc', :conditions => [ 'email LIKE ?', "%@compnow.com.au" ]
  
end