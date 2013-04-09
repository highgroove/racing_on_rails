class AddResultsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :results, :boolean
  end
end
