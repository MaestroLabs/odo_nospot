class AddPublishedByToContent < ActiveRecord::Migration
  def up
    add_column("contents","publishedBy",:string)
  end
  
  def down
    remove_column("contents","publishedBy")
  end
end
