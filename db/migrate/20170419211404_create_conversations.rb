class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|

      t.integer :group_id
      t.string :userA_email
      t.string :userB_email

      t.timestamps
    end
  end
end
