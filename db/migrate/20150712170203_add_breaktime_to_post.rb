class AddBreaktimeToPost < ActiveRecord::Migration
  def change
    add_column :posts, :breaktime, :integer
  end
end
