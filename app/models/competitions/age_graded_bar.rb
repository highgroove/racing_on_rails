# OBRA OverallBar organized by Masters and Juniors age categories
class AgeGradedBar < Competition
  after_create :set_parent

  def points_for(scoring_result)
    scoring_result.points
  end

  def source_results(race)
    Result.all(
                :include => [:race, {:person => :team}, :team, {:race => [:event, :category]}],
                :conditions => [%Q{
                  events.type = 'OverallBar' 
                  and bar = true
                  and events.sanctioned_by = "#{RacingAssociation.current.default_sanctioned_by}"
                  and categories.id = #{race.category.parent(true).id}
                  and people.date_of_birth between '#{race.dates_of_birth.begin}' and '#{race.dates_of_birth.end}'
                  and events.date between '#{date.year}-01-01' and '#{date.year}-12-31'}],
                :order => 'person_id'
    )
  end
  
  def create_races
    self.categories.each do |category|
      self.races.create!(:category => category)
    end
    self.discipline = "Age Graded"
  end
  
  def categories
    template_categories = []
    position = 0
    30.step(65, 5) do |age|
      template_categories << Category.new(:name => "Masters Men #{age}-#{age + 4}", :ages => (age)..(age + 4), :position => position = position.next, :parent => Category.new(:name => 'Masters Men'))
    end
    template_categories << Category.new(:name => 'Masters Men 70+', :ages => 70..999, :position => position = position.next, :parent => Category.new(:name => 'Masters Men'))
    
    30.step(55, 5) do |age|
      template_categories << Category.new(:name => "Masters Women #{age}-#{age + 4}", :ages => (age)..(age + 4), :position => position = position.next, :parent => Category.new(:name => 'Masters Women'))
    end
    template_categories << Category.new(:name => 'Masters Women 60+', :ages => 60..999, :position => position = position.next, :parent => Category.new(:name => 'Masters Women'))
    
    template_categories << Category.new(:name => "Junior Men 10-12", :ages => 10..12, :position => position = position.next, :parent => Category.new(:name => 'Junior Men'))
    template_categories << Category.new(:name => "Junior Men 13-14", :ages => 13..14, :position => position = position.next, :parent => Category.new(:name => 'Junior Men'))
    template_categories << Category.new(:name => "Junior Men 15-16", :ages => 15..16, :position => position = position.next, :parent => Category.new(:name => 'Junior Men'))
    template_categories << Category.new(:name => "Junior Men 17-18", :ages => 17..18, :position => position = position.next, :parent => Category.new(:name => 'Junior Men'))
    
    template_categories << Category.new(:name => "Junior Women 10-12", :ages => 10..12, :position => position = position.next, :parent => Category.new(:name => 'Junior Women'))
    template_categories << Category.new(:name => "Junior Women 13-14", :ages => 13..14, :position => position = position.next, :parent => Category.new(:name => 'Junior Women'))
    template_categories << Category.new(:name => "Junior Women 15-16", :ages => 15..16, :position => position = position.next, :parent => Category.new(:name => 'Junior Women'))
    template_categories << Category.new(:name => "Junior Women 17-18", :ages => 17..18, :position => position = position.next, :parent => Category.new(:name => 'Junior Women'))

    age_graded_categories = Discipline.find_or_create_by_name("Age Graded").bar_categories
    categories = []
    template_categories.each do |template_category|
      if Category.exists?(:name => template_category.parent.name)
        template_category.parent = Category.find_by_name(template_category.parent.name)
      else
        template_category.parent.save!
      end
      
      category = Category.find_by_name(template_category.name)
      if category.nil?
        template_category.save!
        category = template_category
      elsif category.ages != template_category.ages || category.parent != template_category.parent || category.position != template_category.position
        category.ages = template_category.ages
        category.parent = template_category.parent
        category.save!            
      end
      raise "#{category.name} not valid" unless category.valid?
      raise "#{category.name} is new record" if category.new_record?
      raise "#{category.name} does no exist" unless Category.exists?(category.id)
      raise "#{category.name} ages equal 0..999" if category.ages == (0..999)
      unless age_graded_categories.include?(category)
        age_graded_categories << category
      end
      categories << category
    end
    categories
  end
  
  def set_parent
    if parent.nil?
      self.parent = OverallBar.find_or_create_for_year(year)
      save!
    end
  end

  def default_discipline
    "Age Graded"
  end

  def friendly_name
    'Age Graded BAR'
  end
end
