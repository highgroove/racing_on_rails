require 'test_helper'

class RoleAssignmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not be valid without person" do
    role = FactoryGirl.build(:role)
    role_assignment = RoleAssignment.new(:role => role)
    assert !role_assignment.valid?
  end

  test "should not be valid without role" do
    person = FactoryGirl.build(:person)
    role_assignment = RoleAssignment.new(:person => person)
    assert !role_assignment.valid?
  end

  test "should be valid with role and person" do
    role = FactoryGirl.build(:role)
    person = FactoryGirl.build(:person)
    role_assignment = RoleAssignment.new(:person => person, :role => role)
    assert role_assignment.valid?
  end
end
