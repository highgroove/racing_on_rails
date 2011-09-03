require File.expand_path("../../../test_helper", __FILE__)

# :stopdoc:
class IronmanControllerTest < ActionController::TestCase
  def test_index
    big_team = Team.create(:name => "T" * 60)
    weaver = people(:weaver)
    weaver.team = big_team
    events(:banana_belt_1).races.first.results.create(:person => weaver, :team => big_team)
    weaver.first_name = "f" * 60
    weaver.last_name = "T" * 60

    Ironman.calculate!(2004)
    Ironman.calculate!

    get(:index, :year => "2004")
    assert_response(:success)
    assert_template("ironman/index")
    assert_not_nil(assigns["ironman"], "Should assign ironman")
    assert_not_nil(assigns["year"], "Should assign year")
    assert_not_nil(assigns["years"], "Should assign years")

    get :index
    assert_response(:success)
    assert_template("ironman/index")
    assert_not_nil(assigns["ironman"], "Should assign ironman")
    assert_not_nil(assigns["year"], "Should assign year")
    assert_not_nil(assigns["years"], "Should assign years")
  end
end
