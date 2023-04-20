class AddColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string
    add_column :users, :coins, :decimal,precision: 18, scale: 2, default: 0
    add_column :users, :total_deposit, :string
    add_column :users, :children_members, :integer
  end
end
