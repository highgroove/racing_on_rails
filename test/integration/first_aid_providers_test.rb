require File.expand_path("../../test_helper", __FILE__)

# :stopdoc:
class FirstAidProvidersTest < ActionController::IntegrationTest

  # Test sorting
  def test_all_disciplines_empty_results
    https! if ASSOCIATION.ssl?
    get new_person_session_path
    assert_response :success

    post person_session_path(:person_session => { :login => 'admin@example.com', :password => 'secret' })
    assert_redirected_to "/admin"

    get admin_first_aid_providers_path
    assert_select "table#events_table" do
      assert_select "tr:nth-child(2)" do
        assert_select "td:nth-child(4)", :text => "Lost Series"
      end
      assert_select "tr:nth-child(3)" do
        assert_select "td:nth-child(4)", :text => "National Federation Event"
      end
    end
  end
end
