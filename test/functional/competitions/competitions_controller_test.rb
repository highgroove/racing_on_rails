require File.expand_path("../../../test_helper", __FILE__)

# :stopdoc:
class CompetitionsControllerTest < ActionController::TestCase #:nodoc: all
  def test_rider_rankings_no_results
    get(:show, :type => 'rider_rankings')
    assert_response(:success)
    assert_template("competitions/show")
    assert_not_nil(assigns["event"], "Should assign event")
    assert_not_nil(assigns["year"], "Should assign year")
  end

  # How does this happen?
  def test_rider_rankings_result_with_no_person
    RiderRankings.calculate!
    rider_rankings = RiderRankings.find_for_year
    rider_rankings.races.first.results.create!(:place => "1")
    get(:show, :type => 'rider_rankings')
    assert_response(:success)
    assert_template("competitions/show")
    assert_not_nil(assigns["event"], "Should assign event")
    assert_not_nil(assigns["year"], "Should assign year")
  end

  def test_cat4_womens_race_series
    get(:show, :type => 'cat4_womens_race_series')
    assert_response(:success)
    assert_template("competitions/show")
    assert_not_nil(assigns["event"], "Should assign event")
    assert_not_nil(assigns["year"], "Should assign year")
  end

  def test_unknown_competition_type
    assert_raise(ActiveRecord::RecordNotFound) { get(:show, :type => 'not_a_series') }
    assert_response(:success)
  end
end
