class AddPageIdToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :page_id, :integer
  end
end
