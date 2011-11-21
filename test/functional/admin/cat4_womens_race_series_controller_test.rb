require File.expand_path("../../../test_helper", __FILE__)

# :stopdoc:
class Admin::Cat4WomensRaceSeriesControllerTest < ActionController::TestCase
  def setup
    super
    create_administrator_session
    use_ssl
  end

  def test_new_result
    assert_routing('/admin/cat4_womens_race_series/results/new', 
                   :controller => 'admin/cat4_womens_race_series', :action => 'new_result')
    
    get :new_result
    assert_response :success
  end
  
  def test_new_result_with_prepopulated_fields
    get :new_result, :result => { :first_name => "Kevin", :last_name => "Hulick", :team_name => "Vanilla" }
    assert_response :success

    assert_not_nil(assigns(:result), "Should assign result")
    assert_equal("Kevin", assigns(:result).first_name, "first_name")
    assert_equal("Hulick", assigns(:result).last_name, "last_name")
    assert_equal("Vanilla", assigns(:result).team_name, "team_name")
  end
  
  def test_create_result_for_new_event
    FactoryGirl.create(:number_issuer)
    FactoryGirl.create(:discipline)

    post :create_result, { :result => { :place => "3", :number => "123", :team_name => "Gentle Lovers", 
                                        :first_name => "Cheryl", :last_name => "Willson" },
                           :event => { :name => "Mount Hamilton Road Race", "date(1i)" => "2009" , "date(2i)" => "4" , "date(3i)" => "1", 
                                       :sanctioned_by => RacingAssociation.current.short_name},
                           :commit => "Save" 
                         }

    assert_redirected_to new_admin_cat4_womens_race_series_result_path(:result => { 
      :team_name => "Gentle Lovers", :first_name => "Cheryl", :last_name => "Willson"
    })
    
    new_event = SingleDayEvent.find_by_name("Mount Hamilton Road Race")
    assert_not_nil(new_event, "Should have created Mount Hamilton Road Race")
    assert_equal_dates("2009-04-01", new_event.date, "New event date")
    assert_equal(RacingAssociation.current.short_name, new_event.sanctioned_by, "Sanctioned by")

    assert_equal(1, new_event.races.count, "New event should have one race")
    race = new_event.races.first
    women_cat_4 = Category.find_by_name("Women Cat 4")
    assert_equal(women_cat_4, race.category)

    assert_equal(1, race.results.count, "New event race should have one result")
    result = race.results.first    
    assert_equal("3", result.place, "New result place")
    assert_equal("123", result.number, "New result number")
    assert_equal("Gentle Lovers", result.team_name, "New result team_name")
    assert_equal("Cheryl", result.first_name, "New result first_name")
    assert_equal("Willson", result.last_name, "New result last_name")
    assert_not_nil(flash[:notice], "Should have success message in flash")
  end
  
  def test_create_result_for_existing_race_and_people
    FactoryGirl.create(:discipline)
    FactoryGirl.create(:number_issuer)

    # Existing result for someone else
    FactoryGirl.create(:result)

    women_cat_4 = Category.find_or_create_by_name("Women Cat 4")
    event = FactoryGirl.create(:event, :name => "Banana Belt", :date => Date.new(2009, 4, 9))
    existing_race = event.races.create!(:category => women_cat_4)
    molly = FactoryGirl.create(:person, :first_name => "Molly", :last_name => "Cameron", :road_number => "302", :team_name => "Vanilla")

    post :create_result, { :result => { :place => "3", :number => "302", :team_name => "Vanilla", 
                                        :first_name => "Molly", :last_name => "Cameron" },
                           :event => { :name => "Banana Belt", 
                             "date(1i)" => "2009",
                             "date(2i)" => "4",
                             "date(3i)" => "9"
                            },
                           :commit => "Save" 
                         }

    assert_redirected_to new_admin_cat4_womens_race_series_result_path(:result => { 
      :team_name => molly.team_name, :first_name => "Molly", :last_name => "Cameron"
    })
    
    assert_equal(1, SingleDayEvent.count(:all, :conditions => {:name => event.name}))
    event.reload
    assert_equal_dates("2009-04-09", event.date, "New event date")

    assert_equal(1, event.races(true).size, "Event races: #{event.races}")
    race = event.races.detect {|race| race.category == women_cat_4 }
    assert_not_nil(race, "Cat 4 women's race")

    assert_equal(1, race.results.count, "race results")
    result = race.results.sort.last    
    assert_equal("3", result.place, "New result place")
    assert_equal(molly.number(:road), result.number, "New result number")
    assert_equal(molly.team_name, result.team_name, "New result team_name")
    assert_equal(molly.first_name, result.first_name, "New result first_name")
    assert_equal(molly.last_name, result.last_name, "New result last_name")
    
    assert_equal(1, Person.count(:all, :conditions => {:last_name => molly.last_name, :first_name => molly.first_name }), "#{molly.name} in DB")
    
    assert_not_nil(flash[:notice], "Should have success message in flash")
  end
  
  def test_create_result_for_existing_person
    FactoryGirl.create(:number_issuer)
    FactoryGirl.create(:discipline)
    molly = FactoryGirl.create(:person, :first_name => "Molly", :last_name => "Cameron", :road_number => "302", :team_name => "Vanilla")

    post :create_result, { :result => { :place => "3", :number => "302", :team_name => "Vanilla", 
                                        :first_name => "Molly", :last_name => "Cameron" },
                           :event => { :name => "San Ardo Road Race", "date(1i)" => "1999" , "date(2i)" => "1" , "date(3i)" => "24" },
                           :commit => "Save" 
                         }

    assert_redirected_to new_admin_cat4_womens_race_series_result_path(:result => { 
      :team_name => "Vanilla", :first_name => "Molly", :last_name => "Cameron"
    })
    
    assert_equal(1, SingleDayEvent.count(:all, :conditions => {:name => "San Ardo Road Race"}))
    new_event = SingleDayEvent.find_by_name("San Ardo Road Race")
    assert_equal_dates("1999-01-24", new_event.date, "New event date")
    assert_nil(new_event.sanctioned_by, "Sanctioned by")

    assert_equal(1, new_event.races.count, "New event should have one race: #{new_event.races}")
    women_cat_4 = Category.find_by_name("Women Cat 4")
    race = new_event.races.detect {|race| race.category == women_cat_4 }
    assert_not_nil(race, "Cat 4 women's race")

    assert_equal(1, race.results.count, "race results")
    result = race.results.sort.last    
    assert_equal("3", result.place, "New result place")
    assert_equal(molly.number(:road), result.number, "New result number")
    assert_equal(molly.team_name, result.team_name, "New result team_name")
    assert_equal(molly.first_name, result.first_name, "New result first_name")
    assert_equal(molly.last_name, result.last_name, "New result last_name")

    assert_equal(1, Person.count(:all, :conditions => {:last_name => molly.last_name, :first_name => molly.first_name }), "#{molly.name} in DB")

    assert_not_nil(flash[:notice], "Should have success message in flash")
  end

  def test_create_result_for_existing_race_with_different_category
    FactoryGirl.create(:number_issuer)
    FactoryGirl.create(:discipline)

    sr_women_4 = Category.create!(:name => "Sr. Wom 4")
    women_cat_4 = Category.find_or_create_by_name("Women Cat 4")
    women_cat_4.children << sr_women_4
    event = FactoryGirl.create(:event)
    existing_race = event.races.create!(:category => sr_women_4)
    existing_race.results.create!(:place => "1")
    molly = FactoryGirl.create(:person, :first_name => "Molly", :last_name => "Cameron", :road_number => "302", :team_name => "Vanilla")

    post :create_result, { :result => { :place => "3", :number => "302", :team_name => "Vanilla", 
                                        :first_name => "Molly", :last_name => "Cameron" },
                           :event => { :name => event.name, 
                             "date(1i)" => event.date.year.to_s,
                             "date(2i)" => event.date.month.to_s,
                             "date(3i)" => event.date.day.to_s
                            },
                           :commit => "Save" 
                         }

    assert_redirected_to new_admin_cat4_womens_race_series_result_path(:result => { 
     :team_name => molly.team_name, :first_name => "Molly", :last_name => "Cameron"
    })
    
    assert_equal(1, SingleDayEvent.count(:all, :conditions => {:name => event.name}))
    assert_equal(1, event.races(true).size, "New event should have one race: #{event.races}")
    race = event.races.detect {|race| race.category == sr_women_4 }
    assert_not_nil(race, "Cat 4 women's race")

    assert_equal(2, race.results.count, "race results")
    result = race.results.sort.last    
    assert_equal("3", result.place, "New result place")
    assert_equal(molly.number(:road), result.number, "New result number")
    assert_equal(molly.team_name, result.team_name, "New result team_name")
    assert_equal(molly.first_name, result.first_name, "New result first_name")
    assert_equal(molly.last_name, result.last_name, "New result last_name")
    
    assert_equal(1, Person.count(:all, :conditions => {:last_name => molly.last_name, :first_name => molly.first_name }), "#{molly.name} in DB")
    
    assert_not_nil(flash[:notice], "Should have success message in flash")
  end

  
  def test_create_result_no_person_name
    post :create_result, { :result => { :place => "3", :number => "123", :team_name => "Gentle Lovers", 
                                        :first_name => "", :last_name => "" },
                           :event => { :name => "Mount Hamilton Road Race", "date(1i)" => "2009" , "date(2i)" => "4" , "date(3i)" => "1", 
                                       :sanctioned_by => RacingAssociation.current.short_name},
                           :commit => "Save" 
                         }

    assert_response :success
    
    new_event = SingleDayEvent.find_by_name("Mount Hamilton Road Race")
    assert_not_nil(new_event, "Should have created Mount Hamilton Road Race")
    assert_equal_dates("2009-04-01", new_event.date, "New event date")
    assert_equal(RacingAssociation.current.short_name, new_event.sanctioned_by, "Sanctioned by")

    assert_equal(1, new_event.races.count, "New event should have one race")
    race = new_event.races.first
    women_cat_4 = Category.find_by_name("Women Cat 4")
    assert_equal(women_cat_4, race.category)

    assert_equal(0, race.results.count, "New event race should have no results")
    assert(assigns["result"].errors[:first_name], "Should have errors on first name")
  end
end
