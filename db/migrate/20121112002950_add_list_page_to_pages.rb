class AddListPageToPages < ActiveRecord::Migration
  def up
    change_table :pages do |p|
      p.boolean :list_page, :default => true
    end
  end


  def down
    remove_column :pages, :list_page
  end
end
