class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|

      t.string :name
      t.string :school
      t.integer :group_id
      
      t.timestamps
    end
  end
end
