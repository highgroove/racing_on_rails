class Asset < ActiveRecord::Base
  attr_accessible :article, :asset_content_type, :asset_file_name, :asset_file_size, :asset_updated_at, :asset
  belongs_to :article
  has_attached_file :asset

  before_post_process :false
end
