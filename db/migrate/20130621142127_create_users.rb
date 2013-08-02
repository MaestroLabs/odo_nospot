class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "first_name", :limit => 25
      t.string "last_name", :limit => 50
      t.string "email", :default => "", :null => false
      t.string "hashed_password", :limit => 40
      t.string "salt", :limit => 40
      t.date "birthday"
      t.string "gender"
      t.string "permalink"
      t.boolean "editor", :default => false
      t.string "token"
      t.string "activated", :default => false
      t.boolean "thought_leader", :default => false
      t.integer "karma"
      t.timestamps
    end
  end
end
