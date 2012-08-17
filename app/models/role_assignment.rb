class RoleAssignment < ActiveRecord::Base
  belongs_to :person
  belongs_to :role

  validates :person, :role, presence: true
end
