class AddServerToUrls < ActiveRecord::Migration
  def change
    change_table :urls do |t|
      t.references :server
    end
  end
end
