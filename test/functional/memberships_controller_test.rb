require File.expand_path("../../test_helper", __FILE__)

# :stopdoc:
class MembershipsControllerTest < ActionController::TestCase
  def test_show
    login_as :member
    person = member
    get :show, :person_id => person
    assert_equal person, assigns(:person), "@person"
  end
end
