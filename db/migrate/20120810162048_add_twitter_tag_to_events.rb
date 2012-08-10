class AddTwitterTagToEvents < ActiveRecord::Migration
  def change
    add_column :events, :twitter_tag, :string
  end
end
