class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :user_id, :integer
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :school, :string
    add_column :users, :class_year, :integer
    add_column :users, :major, :string
    add_column :users, :image_url, :string, :default => "https://lh4.googleusercontent.com/-jSJrMg5AJqY/AAAAAAAAAAI/AAAAAAAAAQU/6Ps1RMLKfQE/photo.jpg"
    add_column :users, :index_first_time, :string, :default => "yes"
  end
end
