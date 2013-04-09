# Homepage content
class Article < ActiveRecord::Base

  attr_accessible :assets_attributes, :title, :heading, :description, :display, :body, :tag_list, :position, :article_category_id, :results

  has_many :assets
  has_many :taggings
  has_many :tags, through: :taggings
  
  accepts_nested_attributes_for :assets, :allow_destroy => true
  belongs_to :article_category
  acts_as_list :scope => :article_category

  validates :title, :presence => true


  def self.recent_results
    @recent_results = Article.where("display = ? AND results = ?", true, true).order("created_at desc").first(4)
  end


  def self.tagged_with(name)
    Tag.find_by_name!(name).articles
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end
  

  def <=>(other)
    return -1 unless other
    position <=> other.position
  end
end
