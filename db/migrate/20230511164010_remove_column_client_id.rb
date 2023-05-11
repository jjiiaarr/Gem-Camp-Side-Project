class RemoveColumnClientId < ActiveRecord::Migration[7.0]
  def change
    remove_column :bets, :client_id
    add_column :bets, :user_id, :integer
  end
end
