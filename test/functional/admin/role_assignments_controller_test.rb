require File.expand_path("../../../test_helper", __FILE__)

class Admin::RoleAssignmentsControllerTest < ActionController::TestCase
  test "add roles" do
    person = FactoryGirl.create(:person)
    role = FactoryGirl.create(:role)
    post :create, :person_id => person.id, :role_id => role.id
    assert_not_nil assigns(:role_assignment)
    assert_response :success
  end

  test 'remove roles' do
    role_assignment = FactoryGirl.create(:role_assignment)
    delete :destroy, :id => role_assignment.id
    assert_equal 'Removed role.', flash[:notice]
    assert_redirected_to edit_admin_person_path(role_assignment.person)
  end
end
