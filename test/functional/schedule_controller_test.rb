require File.expand_path("../../test_helper", __FILE__)

# :stopdoc:
class ScheduleControllerTest < ActionController::TestCase #:nodoc: all
  # if RacingAssociation.current.short_name == "mbra"
    assert_no_angle_brackets :except => [ :test_index, :test_index_with_alias, :test_mtb_index ]
  # end
  
  def test_index
    events = []
    year = 2006
    
    banana_belt = SingleDayEvent.new(
      :name => "Banana Belt I",
      :city => "Hagg Lake",
      :date => Date.new(year, 1, 22),
      :flyer => "http://#{RacingAssociation.current.static_host}/flyers/2005/banana_belt.html",
      :flyer_approved => true
    )
    events << banana_belt
    banana_belt.save!
    
    mud_slinger = SingleDayEvent.new(
      :name => "Mudslinger",
      :city => "Blodgett",
      :date => Date.new(year, 12, 27),
      :discipline => "Mountain Bike",
      :flyer => "http://#{RacingAssociation.current.static_host}/flyers/2005/mud_slinger.html",
      :flyer_approved => false,
      :promoter => Person.create!(:name => "Mike Ripley", :email => "mikecycle@earthlink.net", :home_phone => "203-259-8577")
    )
    events << mud_slinger
    mud_slinger.save!
    
    SingleDayEvent.create!(:postponed => true)
    get(:index, {:year => year})

    html = @response.body
    for event in events
      assert(html[event.name], "'#{event.name}' should be in HTML")
    end
    assert(html["banana_belt.html"], "Schedule should include Banana Belt flyer URL")
    assert(!html["mud_slinger.html"], "Schedule should not include Mudslinger flyer URL")
  end
  
  def test_index_only_shows_visible_events
    get :index
    html = @response.body
    
    assert_equal(
      RacingAssociation.current.show_only_association_sanctioned_races_on_calendar?,
      !html[events(:future_national_federation_event).name], 
      "Schedule should only show events sanctioned by Association"
    )
    
    assert_equal(
      RacingAssociation.current.show_only_association_sanctioned_races_on_calendar?, 
      !html[events(:usa_cycling_event_with_results).name], 
      "Schedule page should honor RacingAssociation.current.show_only_association_sanctioned_races_on_calendar?"
    )
  end
  
  def tets_road_index
    events = []
    year = 2006
    
    banana_belt = SingleDayEvent.new(
      :name => "Banana Belt I",
      :city => "Hagg Lake",
      :date => Date.new(year, 1, 22),
      :flyer => "http://#{RacingAssociation.current.static_host}/flyers/2005/banana_belt.html",
      :flyer_approved => true
    )
    events << banana_belt
    banana_belt.save!
    
    mud_slinger = SingleDayEvent.new(
      :name => "Mudslinger",
      :city => "Blodgett",
      :date => Date.new(year, 12, 27),
      :discipline => "Mountain Bike",
      :flyer => "http://#{RacingAssociation.current.static_host}/flyers/2005/mud_slinger.html",
      :flyer_approved => false,
      :promoter => Person.create!(:name => "Mike Ripley", :email => "mikecycle@earthlink.net", :home_phone => "203-259-8577")
    )
    events << mud_slinger
    mud_slinger.save!

    get(:index, {:year => year, :discipline => "Road"})

    html = @response.body
    assert(!html["Mudslinger"], "Road events should not include MTB")
    assert(html["banana_belt.html"], "Schedule should include Banana Belt flyer URL")
  end
  
  def test_mtb_index
    events = []
    year = 2006
    
    banana_belt = SingleDayEvent.new(
      :name => "Banana Belt I",
      :city => "Hagg Lake",
      :date => Date.new(year, 1, 22),
      :flyer => "http://#{RacingAssociation.current.static_host}/flyers/2005/banana_belt.html",
      :flyer_approved => true
    )
    events << banana_belt
    banana_belt.save!
    
    mud_slinger = SingleDayEvent.new(
      :name => "Mudslinger",
      :city => "Blodgett",
      :date => Date.new(year, 12, 27),
      :discipline => "Mountain Bike",
      :flyer => "http://#{RacingAssociation.current.static_host}/flyers/2005/mud_slinger.html",
      :flyer_approved => false,
      :promoter => Person.create!(:name => "Mike Ripley", :email => "mikecycle@earthlink.net", :home_phone => "203-259-8577")
    )
    events << mud_slinger
    mud_slinger.save!

    get(:index, {:year => year, :discipline => "Mountain Bike"})

    html = @response.body
    assert(html["Mudslinger"], "Road events should include MTB")
    assert(!html["banana_belt.html"], "Schedule should not include Banana Belt flyer URL")
  end
  
  def test_index_with_alias
    events = []
    year = 2006
    
    banana_belt = SingleDayEvent.new(
      :name => "Banana Belt I",
      :city => "Hagg Lake",
      :date => Date.new(year, 1, 22),
      :flyer => "http://#{RacingAssociation.current.static_host}/flyers/2005/banana_belt.html",
      :flyer_approved => true
    )
    events << banana_belt
    banana_belt.save!
    
    mud_slinger = SingleDayEvent.new(
      :name => "Mudslinger",
      :city => "Blodgett",
      :date => Date.new(year, 12, 27),
      :discipline => "Mountain Bike",
      :flyer => "http://#{RacingAssociation.current.static_host}/flyers/2005/mud_slinger.html",
      :flyer_approved => false,
      :promoter => Person.create!(:name => "Mike Ripley", :email => "mikecycle@earthlink.net", :home_phone => "203-259-8577")
    )
    events << mud_slinger
    mud_slinger.save!

    get(:index, {:year => year, :discipline => "mountain_bike"})

    html = @response.body
    assert(html["Mudslinger"], "Road events should include MTB")
    assert(!html["banana_belt.html"], "Schedule should not include Banana Belt flyer URL")
  end
  
  def test_list
    get :list
    assert_response :success
  end
  
  def test_mtb_list
    events = []
    year = 2006
    
    banana_belt = SingleDayEvent.new(
      :name => "Banana Belt I",
      :city => "Hagg Lake",
      :date => Date.new(year, 1, 22),
      :flyer => "http://#{RacingAssociation.current.static_host}/flyers/2005/banana_belt.html",
      :flyer_approved => true
    )
    events << banana_belt
    banana_belt.save!
    
    mud_slinger = SingleDayEvent.new(
      :name => "Mudslinger",
      :city => "Blodgett",
      :date => Date.new(year, 12, 27),
      :discipline => "Mountain Bike",
      :flyer => "http://#{RacingAssociation.current.static_host}/flyers/2005/mud_slinger.html",
      :flyer_approved => false,
      :promoter => Person.create!(:name => "Mike Ripley", :email => "mikecycle@earthlink.net", :home_phone => "203-259-8577")
    )
    events << mud_slinger
    mud_slinger.save!

    get(:list, {:year => year, :discipline => "Mountain Bike"})

    html = @response.body
    assert(html["Mudslinger"], "Road events should include MTB")
    assert(!html["banana_belt.html"], "Schedule should not include Banana Belt flyer URL")
  end

  def test_calendar_as_json
    get :calendar, :format => "json"
    assert_response :success
  end

  def test_mtb_calendar_as_json
    events = []
    year = 2006

    banana_belt = SingleDayEvent.new(
      :name => "Banana Belt I",
      :city => "Hagg Lake",
      :date => Date.new(year, 1, 22),
      :flyer => "http://#{RacingAssociation.current.static_host}/flyers/2005/banana_belt.html",
      :flyer_approved => true
    )
    events << banana_belt
    banana_belt.save!

    mud_slinger = SingleDayEvent.new(
      :name => "Mudslinger",
      :city => "Blodgett",
      :date => Date.new(year, 12, 27),
      :discipline => "Mountain Bike",
      :flyer => "http://#{RacingAssociation.current.static_host}/flyers/2005/mud_slinger.html",
      :flyer_approved => false,
      :promoter => Person.create!(:name => "Mike Ripley", :email => "mikecycle@earthlink.net", :home_phone => "203-259-8577")
    )
    events << mud_slinger
    mud_slinger.save!

    get(:calendar, {:year => year, :discipline => "Mountain Bike", :format => "json"})

    json = @response.body
    assert(json["Mudslinger"], "Calendar should include MTB event")
    assert(!json["banana_belt.html"], "Schedule should not include Banana Belt flyer URL")
  end

end
