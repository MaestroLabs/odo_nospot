class AddContentCategories < ActiveRecord::Migration
  def up
    add_column("contents","category",:string, :limit => 5)
    add_column("contents","category_at",:datetime)
    add_column("contents","dailyupvotes",:integer)
   
  end

  def down
    remove_column("contents","dailyupvotes")
    remove_column("contents","category_at")
    remove_column("contents","category")
  end
end
