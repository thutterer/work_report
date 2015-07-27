class AddBreakDurationToReports < ActiveRecord::Migration
  def change
    add_column :reports, :break_duration, :time
  end
end
