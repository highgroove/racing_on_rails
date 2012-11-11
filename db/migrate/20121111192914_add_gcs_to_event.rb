class AddGcsToEvent < ActiveRecord::Migration
  def up
    
    change_table :events do |e|
      e.boolean :gcs, :default => false
    end

#    Events.update_all["gcs = ?", false]

  end

  def down
    remove_column :events, :gcs
  end

end

