class CreateBets < ActiveRecord::Migration[7.0]
  def change
    create_table :bets do |t|
      t.integer :item_id
      t.integer :client_id
      t.integer :batch_count
      t.integer :coins, default: 1
      t.string :state
      t.integer :serial_number
      t.timestamps
    end
  end
end
