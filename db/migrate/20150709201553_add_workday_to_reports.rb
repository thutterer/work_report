class AddWorkdayToReports < ActiveRecord::Migration
  def change
    add_column :reports, :workday, :date
  end
end
