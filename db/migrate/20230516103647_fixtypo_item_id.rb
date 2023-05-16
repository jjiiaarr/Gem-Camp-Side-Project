class FixtypoItemId < ActiveRecord::Migration[7.0]
  def change
    remove_reference :bets,:item_id, index: true
    add_reference :bets, :item
  end
end
