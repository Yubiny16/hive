class CreateBudgets < ActiveRecord::Migration[5.0]
  def change
    create_table :budgets do |t|

      t.integer :group_id
      t.integer :group_budget


      t.timestamps
    end
  end
end
