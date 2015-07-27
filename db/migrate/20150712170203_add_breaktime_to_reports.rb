class AddBreaktimeToPost < ActiveRecord::Migration
  def change
    add_column :reports, :breaktime, :integer
  end
end
