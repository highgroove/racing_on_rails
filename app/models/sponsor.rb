class Sponsor < ActiveRecord::Base
  
  has_attached_file :photo
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']


end
