require File.expand_path("../../../test_helper", __FILE__)

# :stopdoc:
class HomeControllerTest < ActionController::TestCase
  def test_index
    FactoryGirl.create(:discipline)
    FactoryGirl.create(:event, :date => 1.day.from_now)
    FactoryGirl.create(:result)
    get(:index, :mobile => '1')
    assert_response :success
    assert_select "div[data-role=page]"
  end
  
  def test_blank_index
    get(:index, :mobile => '1')
    assert_response :success
    assert_not_nil(assigns['upcoming_events'], 'Should assign upcoming_events')
    assert_not_nil(assigns['recent_results'], 'Should assign recent_results')
  end
end
