class CreatePolls < ActiveRecord::Migration[5.0]
  def change
    create_table :polls do |t|

      t.integer :group_id
      t.string :title
      t.datetime :closing_time
      t.boolean :multi_select, :default => false
      t.boolean :anonymous, :default => false

      t.timestamps
    end
  end
end
