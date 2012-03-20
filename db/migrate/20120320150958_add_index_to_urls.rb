class AddIndexToUrls < ActiveRecord::Migration
  def change
    add_index :urls, :url, :unique => true
    add_index :urls, :updated_at
  end
end
