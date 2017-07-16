class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|

      t.string :name
      t.string :school
      t.string :password
      t.string :description
      t.string :email
      t.string :website_address
      t.string :image_url, :default => ""

      t.timestamps
    end

    add_index :groups, :name, unique: true

  end
end
