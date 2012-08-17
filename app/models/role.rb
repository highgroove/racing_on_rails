# Permissions. Only used for Administrator which could be replaced with admin? attribute.
class Role < ActiveRecord::Base
  has_many :role_assignments
  has_many :people, :through => :role_assignments
end
