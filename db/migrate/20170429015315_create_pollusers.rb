class CreatePollusers < ActiveRecord::Migration[5.0]
  def change
    create_table :pollusers do |t|

      t.integer :poll_id
      t.integer :user_id
      t.integer :option_id
      t.boolean :voted, :default => false
      t.timestamps
    end
  end
end
