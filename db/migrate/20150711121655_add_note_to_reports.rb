class AddNoteToReports < ActiveRecord::Migration
  def change
    add_column :reports, :note, :string
  end
end
