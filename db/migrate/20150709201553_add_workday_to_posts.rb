class AddWorkdayToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :workday, :date
  end
end
