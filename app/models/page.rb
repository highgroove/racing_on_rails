# CMS web page. Tree structure. Versioned.
# User render_page helper to look for Page before falling back on Rails templates.
# Pages uses ERb and can execute Ruby code just like a template, so admin users can
# do things like <% Person.destroy_all %>!
class Page < ActiveRecord::Base
  include Concerns::TreeValidation
  include Concerns::Versioned
  include SentientUser

  acts_as_tree  
  
  before_validation :set_slug, :set_path, :set_body
  validates_uniqueness_of :path, :message => "'%{value}' has already been taken"
  
  after_create :update_parent
  after_destroy :update_parent
  has_many :assets
  accepts_nested_attributes_for :assets, :allow_destroy => true
  # Friendly param. Last segment in +path+
  def set_slug
    self.slug = title.downcase.gsub(" ", "_") if slug.blank?
    slug
  end
  
  # Parent +slug+ paths + +slug+
  def set_path
    # Ouch
    _ancestors = ancestors.reverse
    _ancestors.delete(self.parent)
    _ancestors << Page.find(self.parent_id) if self.parent_id
    
    self.path = (_ancestors << self).map(&:slug).join("/").gsub(/^\//, "")
  end
  
  # Can't reliably set default value for MySQL text field
  def set_body
    self.body = "" unless body
    body
  end
  
  def update_parent
    if parent(true)
      parent.skip_version do
        parent.touch
      end
    end
    true
  end

  def valid_parents
    Page.all.delete_if { |page|
      page == self || descendants.include?(page)
    }
  end
  
  def depth
    ancestors.size
  end  

  def to_s
    "#<Page #{id} #{title} #{slug} #{path}>"
  end
end
