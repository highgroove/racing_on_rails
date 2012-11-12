class Asset < ActiveRecord::Base
  attr_accessible :article, :page, :asset_content_type, :asset_file_name, :asset_file_size, :asset_updated_at, :asset
  belongs_to :article
  belongs_to :page
  has_attached_file :asset

  before_post_process :false
end
