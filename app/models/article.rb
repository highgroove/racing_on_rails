# Homepage content
class Article < ActiveRecord::Base
#  attr_accessible :assets_attributes, :title, :heading, :description, :display
  has_many :assets
  accepts_nested_attributes_for :assets, :allow_destroy => true
  belongs_to :article_category
  acts_as_list :scope => :article_category


  

  def <=>(other)
    return -1 unless other
    position <=> other.position
  end
end
