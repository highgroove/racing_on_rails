# Senior Men, Pro 1/2, Novice Masters 45+
# 
# Categories are just a simple hierarchy of names
#
# Categories are basically labels and there is no complex hierarchy. In other words, Senior Men Pro 1/2 and
# Pro 1/2 are two distinct categories. They are not combinations of Pro and Senior and Men and Cat 1
#
# +friendly_param+ is used for friendly links on BAR pages. Example: senior_men
class Category < ActiveRecord::Base
  include Ages
  include Comparable
  include Concerns::Category::FriendlyParam
  include Export::Categories

  acts_as_list
  acts_as_tree
  
  has_many :results
  has_many :races
  
  before_validation :set_friendly_param

  validates_presence_of :name
  validates_presence_of :friendly_param
  validate :parent_is_not_self
   
  NONE = Category.new(:name => "", :id => nil)
  
  # All categories with no parent (except root 'association' category)
  def Category.find_all_unknowns
    Category.all(
      :conditions => ['parent_id is null and name <> ?', RacingAssociation.current.short_name],
      :include => :children
     )
  end
  
  # Sr, Mst, Jr, Cat, Beg, Exp
  def Category.short_name(name)
    return name if name.blank?
    name.gsub('Senior', 'Sr').gsub('Masters', 'Mst').gsub('Junior', 'Jr').gsub('Category', 'Cat').gsub('Beginner', 'Beg').gsub('Expert', 'Exp').gsub("Clydesdale", "Clyd")
  end
  
  def parent_is_not_self
    if parent_id && parent_id == id
      errors.add 'parent', 'Category cannot be its own parent'
    end
  end
  
  # Sr, Mst, Jr, Cat, Beg, Exp
  def short_name
    Category.short_name name
  end
  
  # All children and children childrens
  def descendants
    _descendants = children(true)
    children.each do |child|
      _descendants = _descendants + child.descendants
    end
    _descendants
  end

  # Compare by position, then by name
  def <=>(other)
    return 0 if self[:id] && self[:id] == other[:id]
    diff = (position <=> other.position)
    if diff == 0
      name <=> other.name
    else
      diff
    end
  end

  def to_s
    "#<Category #{id} #{parent_id} #{position} #{name}>"
  end
end
