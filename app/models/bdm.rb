class Bdm < User
  
  default_scope :order => 'name asc', :conditions => ["admin = ?", true]
  
end