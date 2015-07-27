class AddWorkedUntilToReports < ActiveRecord::Migration
  def change
    add_column :reports, :worked_until, :time
  end
end
