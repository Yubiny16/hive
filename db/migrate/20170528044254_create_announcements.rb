class CreateAnnouncements < ActiveRecord::Migration[5.0]
  def change
    create_table :announcements do |t|

      t.integer :group_id
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
