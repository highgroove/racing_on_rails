require File.expand_path("../../../../no_rails_test_case", __FILE__)
require File.expand_path("../../../../../../app/models/competitions/bar/discipline", __FILE__)

# :stopdoc:
# Used to only award bonus points for races of five or less, but now all races get equal points
class Bar::DisciplineTest < NoRailsTestCase
  def setup
    @bar = Object.new
    @bar.extend Bar::Discipline
  end

  def test_discipline_for_road_race
    race = stub("race", :discipline => "Road")
    assert_equal_enumerables [ "Road", "Circuit" ], @bar.disciplines_for(race), "disciplines"
  end

  def test_discipline_for_track
    race = stub("race", :discipline => "Track")
    assert_equal_enumerables [ "Track" ], @bar.disciplines_for(race), "disciplines"
  end

  def test_discipline_for_mtb
    race = stub("race", :discipline => "Mountain Bike")
    assert_equal_enumerables [ "Mountain Bike", "Downhill", "Super D" ], @bar.disciplines_for(race), "disciplines"
  end

  def test_discipline_for_dh
    race = stub("race", :discipline => "Downhill")
    assert_equal_enumerables [ "Downhill" ], @bar.disciplines_for(race), "disciplines"
  end
end
