class AddShortNameToDisciplines < ActiveRecord::Migration
  def change
    add_column :disciplines, :short_name, :string
  end
end
