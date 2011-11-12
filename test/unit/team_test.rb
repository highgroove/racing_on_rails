# coding: utf-8

require File.expand_path("../../test_helper", __FILE__)

# :stopdoc:
class TeamTest < ActiveSupport::TestCase
  def test_find_by_name_or_alias_or_create
    assert_equal(gentle_lovers, Team.find_by_name_or_alias_or_create('Gentle Lovers'), 'Gentle Lovers')
    assert_equal(gentle_lovers, Team.find_by_name_or_alias_or_create('Gentile Lovers'), 'Gentle Lovers alias')
    assert_nil(Team.find_by_name_or_alias('Health Net'), 'Health Net should not exist')
    team = Team.find_by_name_or_alias_or_create('Health Net')
    assert_not_nil(team, 'Health Net')
    assert_equal('Health Net', team.name, 'New team')
  end
  
  def test_merge
    team_to_keep = vanilla
    team_to_merge = gentle_lovers
    
    assert_not_nil(Team.find_by_name(team_to_keep.name), "#{team_to_keep.name} should be in DB")
    assert_equal(2, Result.find_all_by_team_id(team_to_keep.id).size, "Vanilla's results")
    assert_equal(1, Person.find_all_by_team_id(team_to_keep.id).size, "Vanilla's people")
    assert_equal(1, Alias.find_all_by_team_id(team_to_keep.id).size, "Vanilla's aliases")
    
    assert_not_nil(Team.find_by_name(team_to_merge.name), "#{team_to_merge.name} should be in DB")
    assert_equal(1, Result.find_all_by_team_id(team_to_merge.id).size, "Gentle Lovers's results")
    assert_equal(3, Person.find_all_by_team_id(team_to_merge.id).size, "Gentle Lovers's people")
    assert_equal(1, Alias.find_all_by_team_id(team_to_merge.id).size, "Gentle Lovers's aliases")
    
    promoter_events = [ Event.create!(:team => team_to_keep), Event.create!(:team => team_to_merge) ]

    team_to_keep.merge(team_to_merge)
    
    assert_not_nil(Team.find_by_name(team_to_keep.name), "#{team_to_keep.name} should be in DB")
    assert_equal(3, Result.find_all_by_team_id(team_to_keep.id).size, "Vanilla's results")
    assert_equal(4, Person.find_all_by_team_id(team_to_keep.id).size, "Vanilla's people")
    aliases = Alias.find_all_by_team_id(team_to_keep.id)
    lovers_alias = aliases.detect{|a| a.name == 'Gentle Lovers'}
    assert_not_nil(lovers_alias, 'Vanilla should have Gentle Lovers alias')
    assert_equal(3, aliases.size, "Vanilla's aliases")
    
    assert_nil(Team.find_by_name(team_to_merge.name), "#{team_to_merge.name} should not be in DB")
    assert_equal(0, Result.find_all_by_team_id(team_to_merge.id).size, "Gentle Lovers's results")
    assert_equal(0, Person.find_all_by_team_id(team_to_merge.id).size, "Gentle Lovers's people")
    assert_equal(0, Alias.find_all_by_team_id(team_to_merge.id).size, "Gentle Lovers's aliases")
    assert_same_elements(promoter_events, team_to_keep.events(true), "Should merge sponsored events")
  end
  
  def test_merge_with_names
    current_year = Date.today.year
    last_year = current_year - 1

    team_to_keep = Team.create!(:name => "Team Oregon/River City Bicycles")
    team_to_keep_last_year = team_to_keep.names.create!(:name => "Team Oregon/River City Bicycles", :year => last_year)
    
    event = SingleDayEvent.create!
    senior_men = senior_men
    event.races.create!(:category => senior_men).results.create!(:place => "10", :team => team_to_keep)

    event = SingleDayEvent.create!(:date => Date.new(last_year))
    event.races.create!(:category => senior_men).results.create!(:place => "2", :team => team_to_keep)
    
    team_to_merge = Team.create!(:name => "Team O/RCB")
    team_to_merge.names.create!(:name => "Team o IRCB", :year => last_year)
    
    event = SingleDayEvent.create!
    event.races.create!(:category => senior_men).results.create!(:place => "4", :team => team_to_merge)

    event = SingleDayEvent.create!(:date => Date.new(last_year))
    team_to_merge_last_year_result = event.races.create!(:category => senior_men).results.create!(:place => "19", :team => team_to_merge)

    team_to_keep.merge(team_to_merge)
    
    assert(!Team.exists?(team_to_merge.id), "Should delete merged team")
    assert_equal(1, team_to_keep.names.count, "Target team historical names")
    assert_equal(team_to_keep_last_year, team_to_keep.names.first, "Target team historical name")
    
    # If the merged team has historical names, those need to become teams with results from those years
    team_to_merge_last_year = Team.find_by_name("Team o IRCB")
    assert_not_nil(team_to_merge_last_year, "Merged team's historical name should become a new team")
    assert_equal(1, team_to_merge_last_year.results.count, "Merged team's historical name results")
    assert_equal(team_to_merge_last_year_result, team_to_merge_last_year.results.first, "Merged team's historical name results")
    assert_equal(0, team_to_merge_last_year.names.count, "Merged team's historical name historical names")
    
    assert_equal(3, team_to_keep.results.count, "Target team's results")
    assert_equal(1, team_to_keep.names.count, "Target team's historical names")
    assert_equal(1, team_to_keep.aliases.count, "Target team's aliases")
  end
    
  def test_merge_with_names_that_match_existing_team
    current_year = Date.today.year
    last_year = current_year - 1

    team_to_keep = Team.create!(:name => "Team Oregon/River City Bicycles")
    team_to_keep_last_year = team_to_keep.names.create!(:name => "Team Oregon/River City Bicycles", :year => last_year)
        
    team_to_merge = Team.create!(:name => "Team O/RCB")
    team_to_merge.names.create!(:name => "Team o IRCB", :year => last_year)
    
    Team.create!(:name => "Team o IRCB")
    
    team_to_keep.merge(team_to_merge)
  end
  
  def test_find_by_name_or_alias
    # new
    name = 'Brooklyn Cycling Force'
    assert_nil(Team.find_by_name(name), "#{name} should not exist")
    team = Team.find_by_name_or_alias(name)
    assert_nil(Team.find_by_name(name), "#{name} should not exist")
    assert_nil(team, "#{name} should not exist")
    
    # exists
    Team.create(:name => name)
    team = Team.find_by_name_or_alias(name)
    assert_not_nil(team, "#{name} should exist")
    assert_equal(name, team.name, 'name')

    # alias
    Alias.create(:name => 'BCF', :team => team)
    team = Team.find_by_name_or_alias('BCF')
    assert_not_nil(team, "#{name} should exist")
    assert_equal(name, team.name, 'name')
    
    team = Team.find_by_name_or_alias(name)
    assert_not_nil(team, "#{name} should exist")
    assert_equal(name, team.name, 'name')
  end
  
  def test_find_all_by_name_like
    vanilla = vanilla
    assert_same_elements [vanilla], Team.find_all_by_name_like("Vanilla"), "Vanilla"
    assert_same_elements [vanilla], Team.find_all_by_name_like("Vanilla Bicycles"), "Vanilla Bicycles"
    assert_same_elements [vanilla], Team.find_all_by_name_like("van"), "van"
    assert_same_elements [vanilla], Team.find_all_by_name_like("cyc"), "cyc"
    
    steelman = Team.create!(:name => "Steelman Cycles")
    assert_same_elements [steelman, vanilla], Team.find_all_by_name_like("cycles"), "cycles"
  end
  
  def test_create_dupe
    assert_not_nil(Team.find_by_name('Vanilla'), 'Vanilla should exist')
    dupe = Team.new(:name => 'Vanilla')
    assert(!dupe.valid?, 'Dupe Vanilla should not be valid')
  end
  
  def test_create_and_override_alias
    assert_not_nil(Team.find_by_name('Vanilla'), 'Vanilla should exist')
    assert_not_nil(Alias.find_by_name('Vanilla Bicycles'), 'Vanilla Bicycles alias should exist')
    assert_nil(Team.find_by_name('Vanilla Bicycles'), 'Vanilla Bicycles should not exist')

    dupe = Team.create!(:name => 'Vanilla Bicycles')
    assert(dupe.valid?, 'Dupe Vanilla should be valid')
    
    assert_not_nil(Team.find_by_name('Vanilla Bicycles'), 'Vanilla Bicycles should exist')
    assert_not_nil(Team.find_by_name('Vanilla'), 'Vanilla should exist')
    assert_nil(Alias.find_by_name('Vanilla Bicycles'), 'Vanilla Bicycles alias should not exist')
    assert_nil(Alias.find_by_name('Vanilla'), 'Vanilla alias should not exist')
  end
  
  def test_update_to_alias
    assert_not_nil(Team.find_by_name('Vanilla'), 'Vanilla should exist')
    assert_not_nil(Alias.find_by_name('Vanilla Bicycles'), 'Vanilla Bicycles alias should exist')
    assert_nil(Team.find_by_name('Vanilla Bicycles'), 'Vanilla Bicycles should not exist')

    vanilla = vanilla
    vanilla.name = 'Vanilla Bicycles'
    vanilla.save!
    assert(vanilla.valid?, 'Renamed Vanilla should be valid')
    
    assert_not_nil(Team.find_by_name('Vanilla Bicycles'), 'Vanilla Bicycles should exist')
    assert_nil(Team.find_by_name('Vanilla'), 'Vanilla should not exist')
    assert_nil(Alias.find_by_name('Vanilla Bicycles'), 'Vanilla Bicycles alias should not exist')
    assert_not_nil(Alias.find_by_name('Vanilla'), 'Vanilla alias should exist')
  end
  
  def test_update_name_different_case
    vanilla = vanilla
    assert_equal('Vanilla', vanilla.name, 'Name before update')
    vanilla.name = 'vanilla'
    vanilla.save
    assert(vanilla.errors.empty?, 'Should have no errors after save')
    vanilla.reload
    assert_equal('vanilla', vanilla.name, 'Name after update')
  end

  def test_member
    team = Team.new(:name => 'Team Spine')
    assert_equal(false, team.member, 'member')
    team.save!
    team.reload
    assert_equal(false, team.member, 'member')

    team = Team.new(:name => 'California Road Club')
    assert_equal(false, team.member, 'member')
    team.member = true
    assert_equal(true, team.member, 'member')
    team.save!
    team.reload
    assert_equal(true, team.member, 'member')

    team.member = true
    team.save!
    team.reload
    assert_equal(true, team.member, 'member')
  end
  
  def test_name_with_date
    team = Team.create!(:name => "Tecate-Una Mas")
    assert_equal(0, team.names(true).size, "names")
    
    team.names.create!(:name => "Team Tecate", :date => 1.years.ago)
    assert_equal(1, team.names(true).size, "names")
    
    team.names.create!(:name => "Twin Peaks", :date => 2.years.ago)
    assert_equal(2, team.names(true).size, "names")
    
    assert_equal("Tecate-Una Mas", team.name)
    assert_equal("Tecate-Una Mas", team.name(Date.today))
    assert_equal("Team Tecate", team.name(1.years.ago))
    assert_equal("Twin Peaks", team.name(2.years.ago))
    assert_equal("Tecate-Una Mas", team.name(Date.today.next_year))
  end
  
  def test_create_new_name_if_there_are_results_from_previous_year
    team = Team.create!(:name => "Twin Peaks")
    event = SingleDayEvent.create!(:date => 1.years.ago)
    old_result = event.races.create!(:category => senior_men).results.create!(:team => team)
    assert_equal("Twin Peaks", old_result.team_name, "Team name on old result")
    
    event = SingleDayEvent.create!(:date => Date.today)
    result = event.races.create!(:category => senior_men).results.create!(:team => team)
    assert_equal("Twin Peaks", result.team_name, "Team name on new result")
    assert_equal("Twin Peaks", old_result.team_name, "Team name on old result")
    
    team.name = "Tecate-Una Mas"
    team.save!

    assert_equal(1, team.names(true).size, "names")

    assert_equal("Twin Peaks", old_result.team_name, "Team name should stay the same on old result")
    assert_equal("Tecate-Una Mas", result.reload.team_name, "Team name should change on this year's result")
  end
  
  def test_results_before_this_year
    team = Team.create!(:name => "Twin Peaks")
    assert(!team.results_before_this_year?, "results_before_this_year? with no results")
    
    event = SingleDayEvent.create!(:date => Date.today)
    result = event.races.create!(:category => senior_men).results.create!(:team => team)
    assert(!team.results_before_this_year?, "results_before_this_year? with results in this year")
    
    result.destroy
    
    event = SingleDayEvent.create!(:date => 1.years.ago)
    event.races.create!(:category => senior_men).results.create!(:team => team)
    team.results_before_this_year?
    assert(team.results_before_this_year?, "results_before_this_year? with results only a year ago")
    
    event = SingleDayEvent.create!(:date => 2.years.ago)
    event.races.create!(:category => senior_men).results.create!(:team => team)
    team.results_before_this_year?
    assert(team.results_before_this_year?, "results_before_this_year? with several old results")

    event = SingleDayEvent.create!(:date => Date.today)
    event.races.create!(:category => senior_men).results.create!(:team => team)
    team.results_before_this_year?
    assert(team.results_before_this_year?, "results_before_this_year? with results in many years")
  end
  
  def test_rename_multiple_times
    team = Team.create!(:name => "Twin Peaks")    
    event = SingleDayEvent.create!(:date => 3.years.ago)
    result = event.races.create!(:category => senior_men).results.create!(:team => team)
    assert_equal(0, team.names(true).size, "names")
    
    team.name = "Tecate"
    team.save!
    assert_equal(1, team.names(true).size, "names")
    assert_equal(1, team.aliases(true).size, "aliases")
    
    team.name = "Tecate Una Mas"
    team.save!
    assert_equal(1, team.names(true).size, "names")
    assert_equal(2, team.aliases(true).size, "aliases")
    
    team.name = "Tecate-¡Una Mas!"
    team.save!
    assert_equal(1, team.names(true).size, "names")
    assert_equal(3, team.aliases(true).size, "aliases")
    
    assert_equal("Tecate-¡Una Mas!", team.name, "New team name")
    assert_equal("Twin Peaks", team.names.first.name, "Old team name")
    assert_equal(Date.today.year - 1, team.names.first.year, "Old team name year")
  end

  def test_name_date_or_year
    team = vanilla
    team.names.create!(:name => "Sacha's Team", :year => 2001)
    assert_equal("Sacha's Team", team.name(Date.new(2001, 12, 31)), "name for 2001-12-31")
    assert_equal("Sacha's Team", team.name(Date.new(2001)), "name for 2001-01-01")
    assert_equal("Sacha's Team", team.name(2001), "name for 2001")
  end

  def test_multiple_names
    team = vanilla
    team.names.create!(:name => "Mapei", :year => 2001)
    team.names.create!(:name => "Mapei-Clas", :year => 2002)
    team.names.create!(:name => "Quick Step", :year => 2003)
    assert_equal(3, team.names.size, "Historical names. #{team.names.map {|n| n.name}.join(', ')}")
    assert_equal("Mapei", team.name(2000), "Historical name 2000")
    assert_equal("Mapei", team.name(2001), "Historical name 2001")
    assert_equal("Mapei-Clas", team.name(2002), "Historical name 2002")
    assert_equal("Quick Step", team.name(2003), "Historical name 2003")
    assert_equal("Quick Step", team.name(2003), "Historical name 2004")
    assert_equal("Quick Step", team.name(Date.today.year - 1), "Historical name last year")
    assert_equal("Vanilla", team.name(Date.today.year), "Name this year")
    assert_equal("Vanilla", team.name(Date.today.year + 1), "Name next year")
  end
 
  def test_rename_to_old_name
    team = vanilla
    team.names.create!(:name => "Sacha's Team", :year => 2001)
    assert_equal(1, team.names.size, "Historical names")
    assert_equal("Sacha's Team", team.name(2001), "Historical name 2001")
    team.name = "Sacha's Team"
    team.save!
    
    assert_equal("Sacha's Team", team.name, "New name")
  end
  
  def test_rename_to_other_teams_name
    team_o_safeway = Team.create!(:name => "Team Oregon/Safeway")
    team_o_safeway.names.create!(:name => "Team Oregon", :year => 1.years.ago.year)
    
    team_o_river_city = Team.create!(:name => "Team Oregon/River City")
    event = SingleDayEvent.create!(:date => 1.years.ago)
    result = event.races.create!(:category => senior_men).results.create!(:team => team_o_river_city)
    team_o_river_city.name = "Team Oregon"
    team_o_river_city.save!
    
    assert_equal("Team Oregon/Safeway", team_o_safeway.name, "Team Oregon/Safeway name")
    assert_equal(1, team_o_safeway.names.size, "Team Oregon/Safeway historical names")
    assert_equal("Team Oregon", team_o_safeway.names.first.name, "Team Oregon/Safeway historical name")
    
    assert_equal("Team Oregon", team_o_river_city.name, "Team Oregon/River City name")
    assert_equal(1, team_o_river_city.names.size, "Team Oregon/River City historical names")
    assert_equal("Team Oregon/River City", team_o_river_city.names.first.name, "Team Oregon/River City historical name")
  end
  
  # Reproduce UTF-8 conversion issues
  def test_rename_to_alias
    team = Team.create!(:name => "Grundelbruisers/Stewie Bicycles")
    team.names.create!(:name => "Grundelbruisers/Stewie Bicycles", :year => 1.years.ago.year)

    team.reload
    team.name = "Gründelbrüisers/Stewie Bicycles"
    team.save!
    
    team.reload
    assert_equal("Gründelbrüisers/Stewie Bicycles", team.name, "Team name")
    assert_equal(0, team.aliases.count, "aliases")
    assert_equal(1, team.names.count, "Historical names")
  end

  def test_different_teams_with_same_name
    team_o_safeway = Team.create!(:name => "Team Oregon/Safeway")
    team_o_safeway.names.create!(:name => "Team Oregon", :year => 1.years.ago.year)

    team_o_river_city = Team.create!(:name => "Team Oregon/River City")
    team_o_river_city.names.create!(:name => "Team Oregon", :year => 1.years.ago.year)
  end
  
  def test_renamed_teams_should_keep_aliases
    team = Team.create!(:name => "Twin Peaks/The Bike Nook")
    event = SingleDayEvent.create!(:date => 3.years.ago)
    result = event.races.create!(:category => senior_men).results.create!(:team => team)
    team.aliases.create!(:name => "Twin Peaks")
    assert_equal(0, team.names(true).size, "names")
    assert_equal(1, team.aliases(true).size, "Aliases")
    
    team.name = "Tecate"
    team.save!
    assert_equal(1, team.names(true).size, "names")
    assert_equal(2, team.aliases(true).size, "aliases")
    assert_equal(["Twin Peaks", "Twin Peaks/The Bike Nook"], team.aliases.map(&:name).sort, "Should retain keep alias from old name")
  end
end
