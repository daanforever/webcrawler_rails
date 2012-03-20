class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.varchar(64) :url

      t.timestamps
    end
  end
end
