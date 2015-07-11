class AddWorkedFromToPost < ActiveRecord::Migration
  def change
    add_column :posts, :worked_from, :time
  end
end
