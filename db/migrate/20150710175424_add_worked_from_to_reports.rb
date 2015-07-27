class AddWorkedFromToReports < ActiveRecord::Migration
  def change
    add_column :reports, :worked_from, :time
  end
end
