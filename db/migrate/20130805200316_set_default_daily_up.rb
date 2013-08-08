class SetDefaultDailyUp < ActiveRecord::Migration
  def up
    change_column :contents,:dailyupvotes,:integer,:default => 0
    add_column :contents, :lastupvoted, :datetime, :null => false, :default => '2009-01-01 00:00:00'
  end

  def down
    change_column :contents,:dailyupvotes,:integer
    remove_column :contents, :lastupvoted
  end
end
