class FixDatatypeTotalDeposit < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :total_deposit
    add_column :users, :total_deposit, :integer, default: 0
  end
end
