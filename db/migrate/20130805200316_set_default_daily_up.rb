class SetDefaultDailyUp < ActiveRecord::Migration
  def up
    change_column :contents,:dailyupvotes,:integer,:default => 0
  end

  def down
    change_column :contents,:dailyupvotes,:integer
  end
end
