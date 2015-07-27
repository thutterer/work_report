class RenamePostsToReports < ActiveRecord::Migration
  def change
    rename_table :posts, :reports
  end
end
