class AddQuotes < ActiveRecord::Migration
  def up
    add_column("users","quote",:string)
    add_column("contents","quote",:string)
  end

  def down
    remove_column("contents","quote")
    remove_column("users","quote")
  end
end
