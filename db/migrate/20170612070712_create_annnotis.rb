class CreateAnnnotis < ActiveRecord::Migration[5.0]
  def change
    create_table :annnotis do |t|

      t.integer :notification_type # 1 = announcement
      t.integer :announcement_id
      t.integer :group_id
      t.integer :sender
      t.integer :receiver
      t.string :title
      t.binary :content
      t.boolean :read, :default => false

      t.timestamps
    end
  end
end
