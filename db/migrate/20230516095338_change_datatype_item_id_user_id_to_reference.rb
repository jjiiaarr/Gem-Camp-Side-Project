class ChangeDatatypeItemIdUserIdToReference < ActiveRecord::Migration[7.0]
  def change
    remove_column :bets, :item_id
    add_reference :bets, :item_id
  end
end
