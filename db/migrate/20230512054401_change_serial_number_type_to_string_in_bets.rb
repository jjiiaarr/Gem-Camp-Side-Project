class ChangeSerialNumberTypeToStringInBets < ActiveRecord::Migration[7.0]
  def change
    change_column :bets, :serial_number, :string
  end
end
