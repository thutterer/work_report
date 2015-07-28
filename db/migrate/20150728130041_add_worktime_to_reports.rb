class AddWorktimeToReports < ActiveRecord::Migration
  def change
    add_column :reports, :worktime, :float
  end
end
