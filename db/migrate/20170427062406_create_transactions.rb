class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|

      t.integer :value
      t.string :description, :default => "No Description"
      t.integer :budget_id
      t.boolean :pos_neg, :default => true

      t.timestamps
    end
  end
end
