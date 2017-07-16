class CreatePollnotis < ActiveRecord::Migration[5.0]
  def change
    create_table :pollnotis do |t|

      t.integer :notification_type # 2 = poll
      t.integer :group_id
      t.integer :poll_id
      t.integer :sender
      t.integer :receiver
      t.string :title
      t.boolean :read, :default => false

      t.timestamps
    end
  end
end
