# Best All-around Rider Competition. Assigns points for each top-15 placing in major Disciplines: road, track, etc.
# Calculates a BAR for each Discipline, and an Overall BAR that combines all the discipline BARs.
# Also calculates a team BAR.
# Recalculating the BAR at years-end can take nearly 30 minutes even on a fast server. Recalculation must be manually triggered.
# This class implements a number of OBRA-specific rules and should be generalized and simplified.
# The BAR categories and disciplines are all configured in the database. Race categories need to have a bar_category_id to 
# show up in the BAR; disciplines must exist in the disciplines table and discipline_bar_categories.
class Bar < Competition
  validate :valid_dates

  def Bar.calculate!(year = Date.today.year)
    benchmark(name, :level => :info) {
      transaction do
        year = year.to_i if year.is_a?(String)
        date = Date.new(year, 1, 1)
        
        overall_bar = OverallBar.find_or_create_for_year(year)

        # Age Graded BAR, Team BAR and Overall BAR do their own calculations
        Discipline.find_all_bar.reject { |discipline|
          [ Discipline[:age_graded], Discipline[:overall], Discipline[:team] ].include?(discipline)
        }.each do |discipline|
          bar = Bar.first(:conditions => { :date => date, :discipline => discipline.name })
          unless bar
            bar = Bar.create!(
              :parent => overall_bar,
              :name => "#{year} #{discipline.name} BAR",
              :date => date,
              :discipline => discipline.name
            )
          end
        end

        Bar.all( :conditions => { :date => date }).each do |bar|
          bar.destroy_races
          bar.create_races
          # Could bulk load all Event and Races at this point, but hardly seems to matter
          bar.calculate!
        end
      end
    }
    # Don't return the entire populated instance!
    true
  end
  
  def Bar.find_by_year_and_discipline(year, discipline_name)
    Bar.first(:conditions => { :date => Date.new(year), :discipline => discipline_name })
  end

  def point_schedule
    [ 0, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1 ]
  end

  # Source result = counts towards the BAR "race" and BAR results
  # Example: Piece of Cake RR, 6th, Jon Knowlson
  #
  # bar_result, bar_race = BAR itself and placing in the BAR
  # Example: Senior Men BAR, 130th, Jon Knowlson, 45 points
  #
  # BAR results add scoring results as scores
  # Example: 
  # Senior Men BAR, 130th, Jon Knowlson, 18 points
  #  - Piece of Cake RR, 6th, Jon Knowlson 10 points
  #  - Silverton RR, 8th, Jon Knowlson 8 points
  def source_results(race)
    race_disciplines = case race.discipline
    when "Road"
      "'Road', 'Circuit'"
    when "Mountain Bike"
      "'Mountain Bike', 'Downhill', 'Super D'"
    else
      "'#{race.discipline}'"
    end
    
    # Cat 4/5 is a special case. Can't config in database because it's a circular relationship.
    category_ids = category_ids_for(race)
    category_4_5_men = Category.find_by_name("Category 4/5 Men")
    category_4_men = Category.find_by_name("Category 4 Men")
    if category_4_5_men && category_4_men && race.category == category_4_men
      category_ids << ", #{category_4_5_men.id}"
    end

    Result.all(
                :include => [:race, {:person => :team}, :team, {:race => [{:event => { :parent => :parent }}, :category]}],
                :conditions => [%Q{
                  place between 1 AND #{point_schedule.size - 1}
                    and (events.type in ('Event', 'SingleDayEvent', 'MultiDayEvent', 'Series', 'WeeklySeries', 'TaborOverall') or events.type is NULL)
                    and bar = true
                    and events.sanctioned_by = "#{RacingAssociation.current.default_sanctioned_by}"
                    and categories.id in (#{category_ids})
                    and (events.discipline in (#{race_disciplines})
                      or (events.discipline is null and parents_events.discipline in (#{race_disciplines}))
                      or (events.discipline is null and parents_events.discipline is null and parents_events_2.discipline in (#{race_disciplines})))
                    and (races.bar_points > 0
                      or (races.bar_points is null and events.bar_points > 0)
                      or (races.bar_points is null and events.bar_points is null and parents_events.bar_points > 0)
                      or (races.bar_points is null and events.bar_points is null and parents_events.bar_points is null and parents_events_2.bar_points > 0))
                    and events.date between '#{date.year}-01-01' and '#{date.year}-12-31'
                }],
                :order => 'person_id'
      )
  end

  # Really should remove all other top-level categories and their descendants?
  def category_ids_for(race)
    ids = [ race.category_id ]
    ids = ids + race.category.descendants.map(&:id)
    
    if race.category.name == "Masters Men"
      masters_men_4_5 = Category.find_by_name("Masters Men 4/5")
      if masters_men_4_5
        ids.delete masters_men_4_5.id
        ids = ids - masters_men_4_5.descendants.map(&:id)
      end
    end
    
    if race.category.name == "Masters Women"
      masters_women_4 = Category.find_by_name("Masters Women 4")
      if masters_women_4
        ids.delete masters_women_4.id
        ids = ids - masters_women_4.descendants.map(&:id)
      end
    end
    
    ids.join(', ')
  end

  # Apply points from point_schedule, and adjust for field size
  def points_for(source_result, team_size = nil)
    points = 0
    Bar.benchmark('points_for') {
      field_size = source_result.race.field_size

      team_size = team_size || Result.count(:conditions => ["race_id =? and place = ?", source_result.race.id, source_result.place])
      points = point_schedule[source_result.place.to_i] * source_result.race.bar_points / team_size.to_f
      if source_result.race.bar_points == 1 and field_size >= 75
        points = points * 1.5
      end
    }
    points
  end
  
  def create_races
    Discipline[discipline].bar_categories.each do |category|
      races.create!(:category => category)
    end
  end

  def friendly_name
    'BAR'
  end

  def to_s
    "#<#{self.class.name} #{id} #{discipline} #{name} #{date}>"
  end
end
