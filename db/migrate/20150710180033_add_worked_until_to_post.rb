class AddWorkedUntilToPost < ActiveRecord::Migration
  def change
    add_column :posts, :worked_until, :time
  end
end
