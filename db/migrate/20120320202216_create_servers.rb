class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :name, :limit => 64

      t.timestamps
    end
  end
end
