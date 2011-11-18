require File.expand_path("../../../../test_helper", __FILE__)

# :stopdoc:
class CrossCrusadeCallupsTest < ActiveSupport::TestCase  
  def test_calculate
    result = FactoryGirl.create(:result)
    series = CrossCrusadeCallups.create!
    series.source_events << result.event
    CrossCrusadeCallups.calculate!
  end
end