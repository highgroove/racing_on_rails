require File.expand_path("../../../test_helper", __FILE__)

# :stopdoc:
class RacesControllerTest < ActionController::TestCase
  def test_event
    race = FactoryGirl.create(:race)
    get(:index, :event_id => "#{race.event.to_param}", :mobile => '1')
    assert_response(:success)
    assert_template("races/index")
    assert_not_nil(assigns["event"], "Should assign @event")
  end

  def test_show
    race = FactoryGirl.create(:race)
    get(:show, :id => "#{race.to_param}", :mobile => '1')
    assert_response(:success)
    assert_template("races/show")
    assert_not_nil(assigns["race"], "Should assign @race")
  end
end
