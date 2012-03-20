class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url, :limit => 64
      t.timestamps
    end
  end
end
