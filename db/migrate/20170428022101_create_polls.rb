class CreatePolls < ActiveRecord::Migration[5.0]
  def change
    create_table :polls do |t|

      t.integer :group_id
      t.string :title
      t.boolean :anonymous, :default => false
      t.integer :sender
      
      t.timestamps
    end
  end
end
