class CreateAnnouncements < ActiveRecord::Migration[5.0]
  def change
    create_table :announcements do |t|

      t.integer :group_id
      t.string :title
      t.binary :content
      t.string :email
      t.integer :sender

      t.timestamps
    end
  end
end
