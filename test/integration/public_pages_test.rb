require File.expand_path("../../test_helper", __FILE__)

# :stopdoc:
class PublicPagesTest < ActionController::IntegrationTest
  def test_popular_pages
    get "/events/"
    assert_redirected_to schedule_url
  end
  
  def test_results_pages
    FactoryGirl.create(:discipline)
    team = FactoryGirl.create(:team)
    person = FactoryGirl.create(:person, :team => team)
    event = FactoryGirl.create(:event, :date => Date.new(2004, 2))
    senior_men = FactoryGirl.create(:category)
    race = event.races.create!(:category => senior_men)
    result = race.results.create(:place => "1", :person => person, :team => team)

    Ironman.calculate! 2004
    event = Ironman.find_for_year(2004)
    result = event.races.first.results.first
    race = result.race
    get "/events/#{event.to_param}/people/#{person.to_param}/results"
    assert_response :success
    assert_select "a", result.name
    assert_select "h2", result.name
    
    get "/events/#{event.to_param}/teams/#{team.to_param}/results/#{race.to_param}"
    assert_response :success
    assert_select "a", result.team_name
    assert_select "h2", result.team_name
    
    result = FactoryGirl.create(:result)
    get "/events/#{result.event.to_param}"
    assert_response :success
    assert_select "a", result.last_name
    assert_select "h2", result.event.full_name

    get "/events/#{result.event.to_param}/results"
    assert_response :success
    assert_select "a", result.last_name
    assert_select "h2", result.event.full_name
    
    get "/people/#{result.person.to_param}"
    assert_response :success
    assert_select "title", /Results: #{result.name}/
    
    get "/people/#{result.person.to_param}/results"
    assert_response :success
    assert_select "title", /Results: #{result.name}/
    
    get "/teams/#{team.to_param}"
    assert_response :success
    assert_select "title", /Results: #{team.name}/
    
    get "/teams/#{team.to_param}/results"
    assert_response :success
    assert_select "title", /Results: #{team.name}/
  end
  
  def test_first_aid_providers
    person = FactoryGirl.create(:person_with_login, :official => true)
    https! if RacingAssociation.current.ssl?

    get "/admin/first_aid_providers"
    assert_redirected_to new_person_session_url(secure_redirect_options)

    go_to_login
    login :person_session => { :login => person.login, :password => "secret" }
    get "/admin/first_aid_providers"
    assert_response :success
  end

  private
  
  def go_to_login
    https! if RacingAssociation.current.ssl?
    get new_person_session_path
    assert_response :success
    assert_template "person_sessions/new"
  end

  def login(options)
    https! if RacingAssociation.current.ssl?
    post person_session_path, options
    assert_response :redirect
  end
end
