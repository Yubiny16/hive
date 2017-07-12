class CreateGroupfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :groupfiles do |t|

      t.integer :group_id
      t.integer :user_id
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
