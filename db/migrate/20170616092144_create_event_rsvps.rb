class CreateEventRsvps < ActiveRecord::Migration[5.0]
  def change
    create_table :event_rsvps do |t|

      t.integer :group_id
      t.integer :user_id
      t.integer :event_id
      t.string :rsvp

      t.timestamps
    end
  end
end
