class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :title
      t.text :content_md
      t.text :content_html
      t.boolean :draft, default: false
      t.integer :user_id

      # FriendlyId
      t.string :slug

      t.timestamps
    end
    add_index :reports, :user_id
  end
end
