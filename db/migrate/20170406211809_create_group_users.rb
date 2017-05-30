class CreateGroupUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :group_users do |t|

      t.integer :group_id
      t.integer :user_id
      t.integer :ann_notification, :default => 0
      t.integer :cal_notification, :default => 0
      t.integer :budget_notification, :default => 0
      t.integer :poll_notification, :default => 0

      t.timestamps
    end
  end
end
