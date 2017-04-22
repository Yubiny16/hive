class CreateGroupUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :group_users do |t|

      t.integer :group_id
      t.string :email
      t.string :name

      t.timestamps
    end
  end
end
