class AddOvertimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :overtime, :float
  end
end
