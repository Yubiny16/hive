class CreateGroupfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :groupfiles do |t|

      t.integer :group_id
      t.string :file_url
      
      t.timestamps
    end
  end
end
