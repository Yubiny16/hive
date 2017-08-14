class CreateCalnotis < ActiveRecord::Migration[5.0]
  def change
    create_table :calnotis do |t|

      t.integer :event_id
      t.integer :group_id # 0 = personal event noti
      t.integer :sender
      t.integer :receiver
      t.string :title
      t.string :description
      t.datetime :start
      t.datetime :end
      t.boolean :read, :default => false

      t.timestamps
    end
  end
end
