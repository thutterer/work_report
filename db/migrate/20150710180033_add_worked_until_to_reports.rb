class AddWorkedUntilToPost < ActiveRecord::Migration
  def change
    add_column :reports, :worked_until, :time
  end
end
