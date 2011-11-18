# FIXME Assert correct team names on BAR results

require File.expand_path("../../../../test_helper", __FILE__)

# :stopdoc:
class MbraBarTest < ActiveSupport::TestCase
  def test_calculate
    road = FactoryGirl.create(:discipline, :name => "Road")
    FactoryGirl.create(:discipline, :name => "Mountain Bike")
    FactoryGirl.create(:discipline, :name => "Cyclocross")

    senior_men = FactoryGirl.create(:category, :name => "Cat 1/2 Men2")
    senior_women = FactoryGirl.create(:category, :name => "Cat 1/2/3 Women")
    road.bar_categories << senior_men
    road.bar_categories << senior_women

    swan_island = SingleDayEvent.create!(
      :name => "Swan Island",
      :discipline => "Road",
      :date => Date.new(2008, 5, 17)
    )
    swan_island_senior_men = swan_island.races.create(:category => senior_men, :field_size => 5)

    tonkin = FactoryGirl.create(:person)
    swan_island_senior_men.results.create(
      :place => 1,
      :person => tonkin
    )

    molly = FactoryGirl.create(:person)
    swan_island_senior_men.results.create(
      :place => 2,
      :person => molly
    )

    weaver = FactoryGirl.create(:person)
    swan_island_senior_men.results.create(
      :place => 3,
      :person => weaver
    )

    alice = FactoryGirl.create(:person)
    swan_island_senior_men.results.create(
      :place => "dnf",
      :person => alice
    )

    matson = FactoryGirl.create(:person)
    swan_island_senior_men.results.create(
      :place => "dq",
      :person => matson
    )

    member = FactoryGirl.create(:person)
    swan_island_senior_men.results.create(
      :place => "dns",
      :person => member
    )

    # single racer in category
    senior_women_swan_island = swan_island.races.create(:category => senior_women, :field_size => 1)
    senior_women_swan_island.results.create(
      :place => 1,
      :person => molly
    )

    assert_difference "Result.count", 5 do
      MbraBar.calculate!(2008)
    end
    assert_equal(3, MbraBar.count(:conditions => ['date = ?', Date.new(2008)]), "Bar events after calculate!")
    MbraBar.all( :conditions => ['date = ?', Date.new(2008)]).each do |bar|
      assert(bar.name[/2008.*BAR/], "Name #{bar.name} is wrong")
      assert_equal_dates(Date.today, bar.updated_at, "BAR last updated")
    end

    road_bar = MbraBar.find_by_name("2008 Road BAR")
    men_road_bar = road_bar.races.detect {|b| b.category == senior_men }
    assert_equal(senior_men, men_road_bar.category, "Senior Men BAR race BAR cat")
    assert_equal(4, men_road_bar.results.size, "Senior Men Road BAR results")

    men_road_bar.results.sort!
    assert_equal(tonkin, men_road_bar.results[0].person, "Senior Men Road BAR results person")
    assert_equal("1", men_road_bar.results[0].place, "Senior Men Road BAR results place")
    assert_equal(5 + 6, men_road_bar.results[0].points, "Senior Men Road BAR results points")

    assert_equal(weaver, men_road_bar.results[2].person, "Senior Men Road BAR results person")
    assert_equal("3", men_road_bar.results[2].place, "Senior Men Road BAR results place")
    assert_equal(3 + 1, men_road_bar.results[2].points, "Senior Men Road BAR results points")

    assert_equal(alice, men_road_bar.results[3].person, "Senior Men Road BAR results person")
    assert_equal("4", men_road_bar.results[3].place, "Senior Men Road BAR results place - dnf")
    assert_equal(0.5, men_road_bar.results[3].points, "Senior Men Road BAR results points - dnf")

    women_road_bar = road_bar.races.detect {|b| b.category == senior_women }
    assert_equal(senior_women, women_road_bar.category, "Senior Women BAR race BAR cat")
    assert_equal(1, women_road_bar.results.size, "Senior Women Road BAR results")

    assert_equal(molly, women_road_bar.results[0].person, "Senior Women Road BAR results person")
    assert_equal("1", women_road_bar.results[0].place, "Senior Women Road BAR results place")
    assert_equal((1 + 6), women_road_bar.results[0].points, "Senior Women Road BAR results points")

    #championship event - double points
    duck_island = SingleDayEvent.create!(
      :name => "Duck Island",
      :discipline => "Road",
      :date => Date.new(2008, 6, 17),
      :bar_points => 2
    )
    duck_island_senior_men = duck_island.races.create(:category => senior_men, :field_size => 3)

    duck_island_senior_men.results.create(
      :place => 1,
      :person => tonkin
    )
    duck_island_senior_men.results.create(
      :place => 2,
      :person => molly
    )
    #two 2nd place racers both should get 2nd place points
    duck_island_senior_men.results.create(
      :place => 2,
      :person => weaver
    )

    senior_women_duck_island = duck_island.races.create(:category => senior_women, :field_size => 1)
    senior_women_duck_island.results.create(
      :place => 1,
      :person => molly
    )

    # these results should be dropped due to 70% of events rule
    goose_island = SingleDayEvent.create!(
      :name => "Goose Island",
      :discipline => "Road",
      :date => Date.new(2008, 7, 17)
    )
    goose_island_senior_men = goose_island.races.create(:category => senior_men, :field_size => 2)

    goose_island_senior_men.results.create(
      :place => 1,
      :person => tonkin
    )
    goose_island_senior_men.results.create(
      :place => 2,
      :person => molly
    )
    senior_women_goose_island = goose_island.races.create(:category => senior_women, :field_size => 1)
    senior_women_goose_island.results.create(
      :place => 1,
      :person => molly
    )

    assert_difference "Result.count", 0 do
      MbraBar.calculate!(2008)
    end
    assert_equal(3, MbraBar.count(:conditions => ['date = ?', Date.new(2008)]), "Bar events after calculate!")

    road_bar = MbraBar.find_by_name("2008 Road BAR")
    men_road_bar = road_bar.races.detect {|b| b.category == senior_men }
    assert_equal(senior_men, men_road_bar.category, "Senior Men BAR race BAR cat")
    assert_equal(4, men_road_bar.results.size, "Senior Men Road BAR results")

    men_road_bar.results.sort!
    assert_equal(tonkin, men_road_bar.results[0].person, "Senior Men Road BAR results person")
    assert_equal("1", men_road_bar.results[0].place, "Senior Men Road BAR results place")
    assert_equal((5 + 6) + ((3 + 6) * 2), men_road_bar.results[0].points, "Senior Men Road BAR results points")

    assert_equal(molly, men_road_bar.results[1].person, "Senior Men Road BAR results person")
    assert_equal("2", men_road_bar.results[1].place, "Senior Men Road BAR results place")
    assert_equal((4 + 3) + ((2 + 3) * 2), men_road_bar.results[1].points, "Senior Men Road BAR results points")

    assert_equal(weaver, men_road_bar.results[2].person, "Senior Men Road BAR results person")
    assert_equal("3", men_road_bar.results[2].place, "Senior Men Road BAR results place")
    assert_equal((3 + 1) + ((2 + 3) * 2), men_road_bar.results[2].points, "Senior Men Road BAR results points")

    women_road_bar = road_bar.races.detect {|b| b.category == senior_women }
    assert_equal(senior_women, women_road_bar.category, "Senior Women BAR race BAR cat")
    assert_equal(1, women_road_bar.results.size, "Senior Women Road BAR results")

    assert_equal(molly, women_road_bar.results[0].person, "Senior Women Road BAR results person")
    assert_equal("1", women_road_bar.results[0].place, "Senior Women Road BAR results place")
    assert_equal((1 + 6) + ((1 + 6) * 2), women_road_bar.results[0].points, "Senior Women Road BAR results points")

     # No BAR points
     egret_island = SingleDayEvent.create!(
      :name => "Egret Island",
      :discipline => "Road",
      :date => Date.new(2008, 7, 17),
      :bar_points => 0
    )
    senior_women_egret_island = egret_island.races.create(:category => senior_women, :field_size => 99)
    senior_women_egret_island.results.create(
      :place => 1,
      :person => molly
    )

    assert_difference "Result.count", 0 do
      MbraBar.calculate!(2008)
    end

    road_bar = MbraBar.find_by_name("2008 Road BAR")
    women_road_bar = road_bar.races.detect {|b| b.category == senior_women }
    assert_equal(senior_women, women_road_bar.category, "Senior Women BAR race BAR cat")
    assert_equal(1, women_road_bar.results.size, "Senior Women Road BAR results")
    assert_equal(molly, women_road_bar.results[0].person, "Senior Women Road BAR results person")
    assert_equal("1", women_road_bar.results[0].place, "Senior Women Road BAR results place")
    assert_equal((1 + 6) + ((1 + 6) * 2), women_road_bar.results[0].points, "Senior Women Road BAR results points")
  end

  def test_upgrade_scoring
    road = FactoryGirl.create(:discipline, :name => "Road")
    FactoryGirl.create(:discipline, :name => "Mountain Bike")
    FactoryGirl.create(:discipline, :name => "Cyclocross")

    senior_men = FactoryGirl.create(:category, :name => "Cat 1/2 Men2")
    senior_women = FactoryGirl.create(:category, :name => "Cat 1/2/3 Women")
    cat_4_women = FactoryGirl.create(:category, :name => "Cat 4 Women")
    road.bar_categories << senior_men
    road.bar_categories << senior_women
    road.bar_categories << cat_4_women

    swan_island = SingleDayEvent.create!(
      :name => "Swan Island",
      :discipline => "Road",
      :date => Date.new(2008, 5, 17)
    )
    cat_4_women_swan_island = swan_island.races.create(:category => cat_4_women, :field_size => 23)
    molly = FactoryGirl.create(:person)
    cat_4_women_swan_island.results.create(
      :place => 1,
      :person => molly
    )
    goose_island = SingleDayEvent.create!(
      :name => "Goose Island",
      :discipline => "Road",
      :date => Date.new(2008, 7, 17)
    )
    cat_1_2_3_women_goose_island = goose_island.races.create(:category => senior_women, :field_size => 3)
    cat_1_2_3_women_goose_island.results.create(
      :place => 1,
      :person => molly
    )
    
    MbraBar.calculate!(2008)
    road_bar = MbraBar.find_by_name("2008 Road BAR")
    cat_4_women_road_bar = road_bar.races.detect {|b| b.name == "Cat 4 Women" }
    assert_equal(molly, cat_4_women_road_bar.results[0].person, "Cat 4 Women Road BAR results person")
    assert_equal("1", cat_4_women_road_bar.results[0].place, "Cat 4 Women Road BAR results place")
    assert_equal((23 + 6), cat_4_women_road_bar.results[0].points, "Cat 4 Women Road BAR results points")

    cat_1_2_3_women_road_bar = road_bar.races.detect {|b| b.name == "Cat 1/2/3 Women" }
    assert_equal(molly, cat_1_2_3_women_road_bar.results[0].person, "Cat 1/2/3 Women Road BAR results person")
    assert_equal("1", cat_1_2_3_women_road_bar.results[0].place, "Cat 1/2/3 Women Road BAR results place")
    assert_equal(((23 + 6) / 2).to_i + (3 + 6), cat_1_2_3_women_road_bar.results[0].points, "Cat 1/2/3 Women Road BAR results points")

    # test max 30 upgrade points
    duck_island = SingleDayEvent.create!(
      :name => "Duck Island",
      :discipline => "Road",
      :date => Date.new(2008, 6, 17)
    )
    cat_4_women_duck_island = duck_island.races.create(:category => cat_4_women, :field_size => 27)
    cat_4_women_duck_island.results.create(
      :place => 1,
      :person => molly
    )
    MbraBar.calculate!(2008)
    road_bar = MbraBar.find_by_name("2008 Road BAR")
    cat_4_women_road_bar = road_bar.races.detect {|b| b.name == "Cat 4 Women" }
    assert_equal(molly, cat_4_women_road_bar.results[0].person, "Cat 4 Women Road BAR results person")
    assert_equal("1", cat_4_women_road_bar.results[0].place, "Cat 4 Women Road BAR results place")
    assert_equal((23 + 6) + (27 + 6), cat_4_women_road_bar.results[0].points, "Cat 4 Women Road BAR results points")

    cat_1_2_3_women_road_bar = road_bar.races.detect {|b| b.name == "Cat 1/2/3 Women" }
    assert_equal(molly, cat_1_2_3_women_road_bar.results[0].person, "Cat 1/2/3 Women Road BAR results person")
    assert_equal("1", cat_1_2_3_women_road_bar.results[0].place, "Cat 1/2/3 Women Road BAR results place")
    assert_equal(30 + (3 + 6), cat_1_2_3_women_road_bar.results[0].points, "Cat 1/2/3 Women Road BAR results points")
  end
end
