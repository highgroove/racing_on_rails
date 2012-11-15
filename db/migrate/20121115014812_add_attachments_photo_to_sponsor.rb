class AddAttachmentsPhotoToSponsor < ActiveRecord::Migration
  def change
    add_column :sponsors, :photo_file_name, :string
    add_column :sponsors, :photo_content_type, :string
    add_column :sponsors, :photo_file_size, :integer
    add_column :sponsors, :photo_updated_at, :datetime
  end
end
