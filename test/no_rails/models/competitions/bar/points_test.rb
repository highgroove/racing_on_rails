require File.expand_path("../../../../no_rails_test_case", __FILE__)
require File.expand_path("../../../../../../app/models/competitions/bar/points", __FILE__)

# :stopdoc:
# Used to only award bonus points for races of five or less, but now all races get equal points
class Bar::PointsTest < NoRailsTestCase
  def setup
    @bar = Object.new
    @bar.extend Bar::Points
  end

  def test_points_for
    source_result = stub("result", :place => "1", :team_size => 1, :race => stub("race", :event => stub("event"), :field_size => 74, :bar_points => 1))
    assert_equal 15, @bar.points_for(source_result), "points for result"
  end

  def test_points_for_big_race
    source_result = stub("result", :place => "14", :team_size => 1, :race => stub("race", :event => stub("event"), :field_size => 75, :bar_points => 1))
    assert_equal 3, @bar.points_for(source_result), "points for result"
  end

  def test_points_for_high_bar_points
    source_result = stub("result", :place => "14", :team_size => 1, :race => stub("race", :event => stub("event"), :field_size => 74, :bar_points => 3))
    assert_equal 6, @bar.points_for(source_result), "points for result"

    source_result = stub("result", :place => "14", :team_size => 1, :race => stub("race", :event => stub("event"), :field_size => 75, :bar_points => 3))
    assert_equal 6, @bar.points_for(source_result), "points for result"
  end

  def test_points_for_team
    source_result = stub("result", :place => "2", :team_size => 2, :race => stub("race", :event => stub("event"), :field_size => 10, :bar_points => 1))
    assert_equal 7, @bar.points_for(source_result), "points for result with team of 2"

    source_result = stub("result", :place => "3", :team_size => 4, :race => stub("race", :event => stub("event"), :field_size => 10, :bar_points => 1))
    assert_equal 3.25, @bar.points_for(source_result), "decimal points for team"
  end

  def test_points_for_low_place
    source_result = stub("result", :place => "25", :team_size => 1, :race => stub("race", :event => stub("event"), :field_size => 1, :bar_points => 1))
    assert_equal 0, @bar.points_for(source_result), "points"

    source_result = stub("result", :place => "25", :team_size => 2, :race => stub("race", :event => stub("event"), :field_size => 2, :bar_points => 1))
    assert_equal 0, @bar.points_for(source_result), "points"
  end

  def test_points_for_no_place
    source_result = stub("result", :place => "", :team_size => 1, :race => stub("race", :event => stub("event"), :field_size => 1, :bar_points => 1))
    assert_equal 0, @bar.points_for(source_result), "points for result with no place"

    source_result = stub("result", :place => "DNF", :team_size => 1, :race => stub("race", :event => stub("event"), :field_size => 1, :bar_points => 1))
    assert_equal 0, @bar.points_for(source_result), "points for result with no place"

    source_result = stub("result", :place => "DQ", :team_size => 1, :race => stub("race", :event => stub("event"), :field_size => 1, :bar_points => 1))
    assert_equal 0, @bar.points_for(source_result), "points for result with no place"

    source_result = stub("result", :place => "DNS", :team_size => 1, :race => stub("race", :event => stub("event"), :field_size => 1, :bar_points => 1))
    assert_equal 0, @bar.points_for(source_result), "points for result with no place"

    source_result = stub("result", :place => "", :team_size => 4, :race => stub("race", :event => stub("event"), :field_size => 12, :bar_points => 1))
    assert_equal 0, @bar.points_for(source_result), "points for result with no place"
  end
end
